`default_nettype none

module search_and_add
   (
    input wire 		    clk,
    input wire 		    reset,
    output wire 	    ready,
    
    input wire 		    kick,
    output wire 	    busy,

    input wire [128+32-1:0] din,
    input wire 		    we,
    output wire 	    full,

    output wire [31:0] 	    accum_addr,
    output wire [63:0] 	    accum_din,
    output wire 	    accum_we
    );

   logic 		    input_empty;
   logic 		    input_rd;
   logic [128+32-1:0] 	    input_dout;
   logic 		    input_valid;

   logic [128+32-1:0] 	    check_din;
   logic 		    check_we;
   logic 		    check_empty;
   logic 		    check_full;
   logic 		    check_rd;
   logic [128+32-1:0] 	    check_dout;
   logic 		    check_valid;

   logic [128+32-1:0] 	    rest_din;
   logic 		    rest_we;
   logic 		    rest_empty;
   logic 		    rest_full;
   logic 		    rest_rd;
   logic [128+32-1:0] 	    rest_dout;
   logic 		    rest_valid;

   logic [31:0] 	    O_VERSION;
   logic 		    O_READY;
   logic 		    O_WAIT;

   logic 		    O_ACK;
   logic 		    O_ENT_ERR;
   logic 		    O_SINGLE_HIT;
   logic 		    O_MULTI_HIT;
   logic [127:0] 	    O_KEY_DAT;
   logic [127:0] 	    O_EKEY_MSK;
   logic [6:0] 		    O_KEY_PRI;
   logic [31:0] 	    O_KEY_VALUE;
   logic 		    O_CMD_EMPTY;
   logic 		    O_CMD_FULL;
   logic 		    O_ENT_FULL;
   logic [31:0] 	    O_KERNEL_STATUS;
   logic [15:0] 	    O_ENT_ADDR;

   logic 		    I_CMD_INIT;
   logic 		    I_CMD_VALID;
   logic 		    I_CMD_ERASE;
   logic 		    I_CMD_WRITE;
   logic 		    I_CMD_READ;
   logic 		    I_CMD_SEARCH;
   logic 		    I_CMD_UPDATE;
   logic [127:0] 	    I_KEY_DAT;
   logic [127:0] 	    I_EKEY_MSK;
   logic [6:0] 		    I_KEY_PRI;
   logic [31:0] 	    I_KEY_VALUE;

   logic [7:0] 		    state_counter = 8'd0;
   logic [7:0] 		    input_counter = 8'd0;

   logic 		    busy_reg;
   logic [31:0] 	    accum_addr_reg;
   logic [63:0] 	    accum_din_reg;
   logic 		    accum_we_reg;

   assign busy = busy_reg;
   
   assign accum_addr = accum_addr_reg;
   assign accum_din = accum_din_reg;
   assign accum_we = accum_we_reg;

   always @(posedge clk) begin
      if(reset == 1'b1) begin
	 busy_reg <= 1'b0;
	 state_counter <= 8'd0;
	 input_counter <= 8'd0;

	 input_rd <= 1'b0;
	 check_we <= 1'b0;
	 check_rd <= 1'b0;
	 rest_we <= 1'b0;
	 rest_rd <= 1'b0;
	 
	 I_CMD_INIT <= 1'b0;
	 I_CMD_VALID <= 1'b0;
	 I_CMD_ERASE <= 1'b0;
	 I_CMD_WRITE <= 1'b0;
	 I_CMD_READ <= 1'b0;
	 I_CMD_SEARCH <= 1'b0;
	 I_CMD_UPDATE <= 1'b0;
	 I_KEY_DAT <= 128'h0;
	 I_EKEY_MSK <= 128'h0;
	 I_KEY_PRI <= 7'd0;
	 I_KEY_VALUE <= 32'h0;

	 accum_addr_reg <= 32'h0;
	 accum_din_reg <= 64'h0;
	 accum_we_reg <= 1'h0;

      end else begin
	 
	 case (state_counter)

	   // wait for kick
	   0 : begin
	      if(kick == 1'b1) begin
		 busy_reg <= 1'b1;
		 state_counter <= state_counter + 1;
	      end else begin
		 busy_reg <= 1'b0;
	      end
	      input_counter <= 8'd0;
	      accum_we_reg <= 1'b0;
	      I_CMD_VALID <= 1'b0;
	      input_rd <= 1'b0;
	      rest_we <= 1'b0;
	      rest_rd <= 1'b0;
	      check_we <= 1'b0;
	      check_rd <= 1'b0;
	   end
	   
	   // emit all input data
	   1 : begin
	      rest_rd <= 1'b0;

	      // for all input data
	      if(input_empty == 1'b1 && input_counter == 0) begin
		 state_counter <= state_counter + 1;
	      end

	      // emit valid input data to Axonerve
	      if(input_valid == 1'b1) begin
		 input_rd <= 1'b1;
		 I_CMD_VALID <= 1'b1;
		 I_CMD_SEARCH <= 1'b1;
		 I_KEY_DAT <= input_dout[128-1:0];
		 I_KEY_VALUE <= input_dout[128+32-1:128];
		 check_we <= 1'b1;
		 check_din <= input_dout;
	      end else begin
		 input_rd <= 1'b0;
		 I_CMD_VALID <= 1'b0;
		 check_we <= 1'b0;
	      end

	      // treat response returned from Axonerve
	      if(O_ACK == 1'b1) begin
		 check_rd <= 1'b1; // consume a check entry
		 if(O_SINGLE_HIT == 1'b1 || O_MULTI_HIT == 1'b1) begin
		    // hit 
		    accum_addr_reg[15:0] <= O_ENT_ADDR[15:0];
		    accum_din_reg[63:32] <= O_KEY_VALUE[31:0];
		    accum_din_reg[31:0] <= 32'h1;
		    accum_we_reg <= 1'b1;
		    rest_we <= 1'b0;
		 end else begin
		    // no such data, add them
		    accum_we_reg <= 1'b0;
		    rest_we <= 1'b1;
		    rest_din <= check_dout;
		 end
	      end else begin // if (O_ACK == 1'b1)
		 accum_we_reg <= 1'b0;
		 rest_we <= 1'b0;
		 check_rd <= 1'b0;
	      end

	      if(O_ACK == 1'b0 && input_valid == 1'b1) begin
		 // increase the counter to receive
		 input_counter <= input_counter + 1;
	      end else if(O_ACK == 1'b1 && input_valid == 1'b0) begin
		 // decrease the counter to receive
		 input_counter <= input_counter - 1;
	      end
	      
	   end // case: 1

	   // add new data
	   2 : begin
	      input_rd <= 1'b0;
	      rest_we <= 1'b0;
	      check_we <= 1'b0;
	      check_rd <= 1'b0;

	      if(rest_empty == 1'b1 && input_counter == 0) begin
		 state_counter <= 0; // done
		 busy_reg <= 1'b0;
	      end

	      if(O_ACK == 1'b1) begin
		 accum_addr_reg[15:0] <= O_ENT_ADDR[15:0];
		 accum_din_reg[63:32] <= O_KEY_VALUE[31:0];
		 accum_din_reg[31:0] <= 32'h1;
		 accum_we_reg <= 1'b1;
	      end else begin
		 accum_we_reg <= 1'b0;
	      end

	      // emit valid input data to Axonerve
	      if(rest_valid == 1'b1) begin
		 rest_rd <= 1'b1;
		 I_CMD_VALID <= 1'b1;
		 I_CMD_UPDATE <= 1'b1;
		 I_KEY_DAT <= rest_dout[128-1:0];
		 I_KEY_VALUE <= rest_dout[128+32-1:128];
	      end else begin
		 rest_rd <= 1'b0;
		 I_CMD_VALID <= 1'b0;
	      end // else: !if(rest_valid == 1'b1)

	      if(rest_valid == 1'b1 && O_ACK == 1'b0) begin
		 input_counter <= input_counter + 1;
	      end else if(rest_valid == 1'b0 && O_ACK == 1'b1) begin
		 input_counter <= input_counter - 1;
	      end
	      
	   end // case: 2
	   
	   default: begin
	      state_counter <= 0;
	      input_counter <= 0;
	      accum_we_reg <= 1'b0;
	      I_CMD_VALID <= 1'b0;
	      input_rd <= 1'b0;
	      rest_we <= 1'b0;
	      rest_rd <= 1'b0;
	      check_we <= 1'b0;
	      check_rd <= 1'b0;
	   end // case: default
	   
	 endcase // case (state_counter)
	 
      end
   end

   assign ready = O_READY;
   
   axonerve_kvs_kernel AXONERVE(
				.I_CLK(clk),
				.I_CLKX2(1'b0), // not used
				.I_XRST(~reset),
				.O_VERSION(O_VERSION),
				.O_READY(O_READY),
				.O_WAIT(O_WAIT),

				.O_ACK(O_ACK),
				.O_ENT_ERR(O_ENT_ERR),
				.O_SINGLE_HIT(O_SINGLE_HIT),
				.O_MULTI_HIT(O_MULTI_HIT),
				.O_KEY_DAT(O_KEY_DAT),
				.O_EKEY_MSK(O_EKEY_MSK),
				.O_KEY_PRI(O_KEY_PRI),
				.O_KEY_VALUE(O_KEY_VALUE),
				.O_CMD_EMPTY(O_CMD_EMPTY),
				.O_CMD_FULL(O_CMD_FULL),
				.O_ENT_FULL(O_ENT_FULL),
				.O_KERNEL_STATUS(O_KERNEL_STATUS),
				.O_ENT_ADDR(O_ENT_ADDR),

				.I_CMD_INIT(I_CMD_INIT),
				.I_CMD_VALID(I_CMD_VALID),
				.I_CMD_ERASE(I_CMD_ERASE),
				.I_CMD_WRITE(I_CMD_WRITE),
				.I_CMD_READ(I_CMD_READ),
				.I_CMD_SEARCH(I_CMD_SEARCH),
				.I_CMD_UPDATE(I_CMD_UPDATE),
				.I_KEY_DAT(I_KEY_DAT),
				.I_EKEY_MSK(I_EKEY_MSK),
				.I_KEY_PRI(I_KEY_PRI),
				.I_KEY_VALUE(I_KEY_VALUE)
			    );
   
   fifo_160_16_ft input_buf (
			     .clk (clk),
			     .srst(reset),
			     .din      (din),
			     .wr_en    (we),
			     .full     (),
			     .empty    (input_empty),
			     .prog_full(full),
			     .rd_en    (input_rd),
			     .dout     (input_dout),
			     .valid    (input_valid),
			     .wr_rst_busy(),
			     .rd_rst_busy()
			     );

   fifo_160_16_ft rest_buf (
			    .clk (clk),
			    .srst(reset),
			    .din      (rest_din),
			    .wr_en    (rest_we),
			    .full     (),
			    .empty    (rest_empty),
			    .prog_full(rest_full),
			    .rd_en    (rest_rd),
			    .dout     (rest_dout),
			    .valid    (rest_valid),
			    .wr_rst_busy(),
			    .rd_rst_busy()
			    );
   
   fifo_160_16_ft check_buf (
			    .clk (clk),
			    .srst(reset),
			    .din      (check_din),
			    .wr_en    (check_we),
			    .full     (),
			    .empty    (check_empty),
			    .prog_full(check_full),
			    .rd_en    (check_rd),
			    .dout     (check_dout),
			    .valid    (check_valid),
			    .wr_rst_busy(),
			    .rd_rst_busy()
			    );
   

endmodule // search_and_add
   
`default_nettype none
   
