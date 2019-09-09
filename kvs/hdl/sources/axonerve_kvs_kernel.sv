
`default_nettype none

module axonerve_kvs_kernel (
			    input wire 		 I_CLK,
			    input wire 		 I_CLKX2,
			    input wire 		 I_XRST, // active low
			    output logic [31:0]  O_VERSION,
			    output logic 	 O_READY,
			    output logic 	 O_WAIT,

			    output logic 	 O_ACK,
			    output logic 	 O_ENT_ERR,
			    output logic 	 O_SINGLE_HIT,
			    output logic 	 O_MULTI_HIT,
			    output logic [127:0] O_KEY_DAT,
			    output logic [127:0] O_EKEY_MSK,
			    output logic [6:0] 	 O_KEY_PRI,
			    output logic [31:0]  O_KEY_VALUE,
			    output logic 	 O_CMD_EMPTY,
			    output logic 	 O_CMD_FULL,
			    output logic 	 O_ENT_FULL,
			    output logic [31:0]  O_KERNEL_STATUS,
			    output logic [15:0]	 O_ENT_ADDR,

			    input wire 		 I_CMD_INIT,
			    input wire 		 I_CMD_VALID,
			    input wire 		 I_CMD_ERASE,
			    input wire 		 I_CMD_WRITE,
			    input wire 		 I_CMD_READ,
			    input wire 		 I_CMD_SEARCH,
			    input wire 		 I_CMD_UPDATE,
			    input wire [127:0] 	 I_KEY_DAT,
			    input wire [127:0] 	 I_EKEY_MSK,
			    input wire [6:0] 	 I_KEY_PRI,
			    input wire [31:0] 	 I_KEY_VALUE
			    );
   
   logic 					 OACK;
   logic 					 OENT_ERR;
   logic 					 OSHIT;
   logic 					 OMHIT;
   logic [15:0] 				 OSRCH_ENT_ADD;
   logic 					 OXMATCH_WAIT;
   logic [127:0] 				 OKEY_DAT;
   logic [127:0] 				 OEKEY_MSK;
   logic [6:0] 					 OKEY_PRI;
   logic [31:0] 				 OKEY_VALUE;
   logic [16:0] 				 OREG_SERC_MEM_RDT;
   logic [31:0] 				 OVERSION;
   logic 					 OFIFO_FULL;
   
   logic 					 XRST;
   logic 					 ICLK;
   //logic 					 ICLKX2;
   logic 					 ICAM_IE = 1'b0;
   logic 					 ICAM_WE = 1'b0;
   logic 					 ICAM_RE = 1'b0;
   logic 					 ICAM_SE = 1'b0;
   logic [15:0] 				 IENT_ADD = 16'd0;
   logic 					 ICODE_MODE = 1'b0;
   logic [127:0] 				 IKEY_DAT = 128'd0;
   logic [127:0] 				 IEKEY_MSK = 128'd0;
   logic [6:0] 					 IKEY_PRI = 7'd0;
   logic [31:0] 				 IKEY_VALUE = 32'd0;
   logic 					 IREG_DBG = 1'b0;
   logic [2:0] 					 IREG_CLUS_SEL = 3'd0;
   logic [4:0] 					 IREG_SERC_MEM_SEL = 5'd0;
   logic [15:0] 				 IREG_SERC_MEM_ADR = 16'd0;
   logic 					 IREG_SERC_MEM_XRW = 1'b0;
   logic 					 IREG_SERC_MEM_DON = 1'b0;
   logic [16:0] 				 IREG_SERC_MEM_WDT = 17'd0;

   assign O_VERSION = OVERSION;

   assign ICLK = I_CLK;
   //assign ICLKX2 = I_CLKX2;
   //assign XRST = I_XRST && ~I_CMD_INIT;
   assign XRST = I_XRST;
   
   AXONERVE_A01 U(
		  .OACK(OACK),
		  .OENT_ERR(OENT_ERR),
		  .OSHIT(OSHIT),
		  .OMHIT(OMHIT),
		  .OSRCH_ENT_ADD(OSRCH_ENT_ADD),
		  .OXMATCH_WAIT(OXMATCH_WAIT),
		  .OKEY_DAT(OKEY_DAT),
		  .OEKEY_MSK(OEKEY_MSK),
		  .OKEY_PRI(OKEY_PRI),
		  .OKEY_VALUE(OKEY_VALUE),
		  .OREG_SERC_MEM_RDT(OREG_SERC_MEM_RDT),
		  .OVERSION(OVERSION), 
		  .OFIFO_FULL(OFIFO_FULL),
		  .IXRST(XRST),
		  .ICLK(ICLK),
		  //.ICLKX2(ICLKX2),
		  .ICAM_IE(ICAM_IE),
		  .ICAM_WE(ICAM_WE),
		  .ICAM_RE(ICAM_RE),
		  .ICAM_SE(ICAM_SE),
		  .IENT_ADD(IENT_ADD),
		  .ICODE_MODE(ICODE_MODE),
		  .IKEY_DAT(IKEY_DAT), 
		  .IEKEY_MSK(IEKEY_MSK),
		  .IKEY_PRI(IKEY_PRI),
		  .IKEY_VALUE(IKEY_VALUE),
		  .IREG_DBG(IREG_DBG),
		  .IREG_CLUS_SEL(IREG_CLUS_SEL),
		  .IREG_SERC_MEM_SEL(IREG_SERC_MEM_SEL), 
		  .IREG_SERC_MEM_ADR(IREG_SERC_MEM_ADR),
		  .IREG_SERC_MEM_XRW(IREG_SERC_MEM_XRW),
		  .IREG_SERC_MEM_DON(IREG_SERC_MEM_DON),
		  .IREG_SERC_MEM_WDT(IREG_SERC_MEM_WDT)
		  );

   logic [299:0] 				 cmd_din;
   logic 					 cmd_we;
   logic 					 cmd_rd = 1'b0;
   logic [299:0] 				 cmd_q;
   logic 					 cmd_full;
   logic 					 cmd_empty;
   logic 					 cmd_valid;
   logic [4:0] 					 cmd_count;
   logic 					 cmd_prog_full;
   logic 					 cmd_wr_rst_busy;
   logic 					 cmd_rd_rst_busy;

   assign O_CMD_EMPTY = cmd_empty;
   assign O_CMD_FULL = cmd_prog_full;
   
   fifo_300_16_ft u_cmd_fifo(
			     .clk(ICLK),
			     .srst(~XRST),
			     .din(cmd_din),
			     .wr_en(cmd_we),
			     .rd_en(cmd_rd),
			     .dout(cmd_q),
			     .full(cmd_full),
			     .empty(cmd_empty),
			     .valid(cmd_valid),
			     .data_count(cmd_count),
			     .prog_full(cmd_prog_full),
			     .wr_rst_busy(cmd_wr_rst_busy),
			     .rd_rst_busy(cmd_rd_rst_busy)
			     );
   assign cmd_we = I_CMD_VALID;
   assign cmd_din[127:0]   = I_KEY_DAT;
   assign cmd_din[255:128] = I_EKEY_MSK;
   assign cmd_din[262:256] = I_KEY_PRI;
   assign cmd_din[294:263] = I_KEY_VALUE;
   assign cmd_din[295] = I_CMD_ERASE;
   assign cmd_din[296] = I_CMD_WRITE;
   assign cmd_din[297] = I_CMD_READ;
   assign cmd_din[298] = I_CMD_SEARCH;
   assign cmd_din[299] = I_CMD_UPDATE;
   
   logic [127:0] 				 key_data;
   logic [127:0] 				 ekey_msk;
   logic [6:0] 					 key_pri;
   logic [31:0] 				 key_value;
   logic 					 cmd_erase;
   logic 					 cmd_write;
   logic 					 cmd_read;
   logic 					 cmd_search;
   logic 					 cmd_update;

   always_comb begin
      key_data <= cmd_q[127:0];
      ekey_msk <= cmd_q[255:128];
      key_pri <= cmd_q[262:256];
      key_value <= cmd_q[294:263];
      if(cmd_q[295] == 1'b1) begin
	 {cmd_erase, cmd_write, cmd_read, cmd_search, cmd_update} <= 5'b10000;
      end else if (cmd_q[296] == 1'b1) begin
	 {cmd_erase, cmd_write, cmd_read, cmd_search, cmd_update} <= 5'b01000;
      end else if (cmd_q[297] == 1'b1) begin
	 {cmd_erase, cmd_write, cmd_read, cmd_search, cmd_update} <= 5'b00100;
      end else if (cmd_q[298] == 1'b1) begin
	 {cmd_erase, cmd_write, cmd_read, cmd_search, cmd_update} <= 5'b00010;
      end else if (cmd_q[299] == 1'b1) begin
	 {cmd_erase, cmd_write, cmd_read, cmd_search, cmd_update} <= 5'b00001;
      end else begin
	 {cmd_erase, cmd_write, cmd_read, cmd_search, cmd_update} <= 5'b00000;
      end
   end
   
   logic [15:0] 	  ent_addr_din = 16'd0;
   logic 		  ent_addr_we = 1'b0;
   logic 		  ent_addr_rd = 1'b0;
   logic [15:0] 	  ent_addr_q;
   logic 		  ent_addr_full;
   logic 		  ent_addr_empty;
   logic 		  ent_addr_valid;
   logic 		  ent_addr_prog_full;
   logic 		  ent_addr_prog_empty;
   logic 		  ent_addr_wr_rst_busy;
   logic 		  ent_addr_rd_rst_busy;

   assign O_ENT_FULL = ent_addr_prog_empty;

   fifo_16_128k_ft u_addr_fifo(
			       .clk(ICLK),
			       .srst(~XRST),
			       .din(ent_addr_din),
			       .wr_en(ent_addr_we),
			       .rd_en(ent_addr_rd),
			       .dout(ent_addr_q),
			       .full(ent_addr_full),
			       .empty(ent_addr_empty),
			       .valid(ent_addr_valid),
			       .prog_full(ent_addr_prog_full),
			       .prog_empty(ent_addr_prog_empty),
			       .wr_rst_busy(ent_addr_wr_rst_busy),
			       .rd_rst_busy(ent_addr_rd_rst_busy)
			       );

   
   logic 		  READY; // the flag whether the module reset has been done
   assign O_READY = READY;

   // reset AXONERVE
   logic 		  AXONERVE_READY = 1'b0;
   logic 		  OXMATCH_WAIT_d = 1'b0;
   always @(posedge ICLK) begin
      OXMATCH_WAIT_d <= OXMATCH_WAIT;
      if(XRST == 1'b0) begin
	 AXONERVE_READY <= 1'b0;
      end else if(OXMATCH_WAIT_d == 1'b0 && OXMATCH_WAIT == 1'b1) begin
	 AXONERVE_READY <= 1'b1;
      end
   end

   // reset CMD_FIFO
   logic CMD_FIFO_READY = 1'b0;
   always @(posedge ICLK) begin
      if(XRST == 1'b0) begin
	 CMD_FIFO_READY <= 1'b0;
      end else if(cmd_wr_rst_busy == 1'b0 && cmd_rd_rst_busy == 1'b0) begin
	 CMD_FIFO_READY <= 1'b1;
      end
   end // always @ (posedge ICLK)
   
   // reset ENT_ADDR_FIFO
   logic ENT_ADDR_FIFO_READY = 1'b0;
   logic ent_addr_fifo_init_flag = 1'b0;
   logic ent_addr_fifo_init_done = 1'b0;
   logic [3:0] ent_addr_fifo_init_state = 4'd0;
   always @(posedge ICLK) begin
      if(XRST == 1'b0) begin
	 ENT_ADDR_FIFO_READY <= 1'b0;
	 ent_addr_fifo_init_flag <= 1'b0;
	 ent_addr_fifo_init_state <= 4'd0;
      end else if(ent_addr_fifo_init_state == 4'd0 && ent_addr_wr_rst_busy == 1'b0 && ent_addr_rd_rst_busy == 1'b0) begin
	 ENT_ADDR_FIFO_READY <= 1'b0;
	 ent_addr_fifo_init_flag <= 1'b1;
	 ent_addr_fifo_init_state <= 4'd1;
      end else if(ent_addr_fifo_init_state == 4'd1) begin
	 ent_addr_fifo_init_flag <= 1'b0;
	 if(ent_addr_fifo_init_flag == 1'b0 && ent_addr_fifo_init_done == 1'b1) begin
	    ENT_ADDR_FIFO_READY <= 1'b1;
	 end
      end else begin
	 // nothing to do
      end
   end // always @ (posedge ICLK)
   
   assign READY = AXONERVE_READY && CMD_FIFO_READY && ENT_ADDR_FIFO_READY;
   assign O_KERNEL_STATUS[11:8] = {I_CMD_INIT, AXONERVE_READY, CMD_FIFO_READY, ENT_ADDR_FIFO_READY};

   logic WAIT_FLAG = 1'b1;
   assign O_WAIT = WAIT_FLAG;

   logic [7:0] state_counter;
   logic [15:0] ent_addr_fifo_init_addr;
   logic [7:0] 	request_counter;

   localparam IDLE             = 8'd0;
   localparam INTERNAL_INIT    = 8'd1;
   localparam MAIN_LOOP        = 8'd2;
   localparam WAIT_FOR_ACK     = 8'd3;
   localparam FLUSH_AND_OP_ADD = 8'd4;
   localparam OP_ERASE         = 8'd5;
   localparam OP_UPDATE        = 8'd6;
   
   always @(posedge ICLK) begin

      if(XRST == 1'b0) begin
	 
	 WAIT_FLAG <= 1'b1;
	 {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b000;
	 IENT_ADD <= 16'h0000;
	 ICODE_MODE <= 1'b0;
	 IKEY_DAT <= 128'h00000000_00000000_00000000_00000000;
	 IEKEY_MSK <= 128'h00000000_00000000_00000000_00000000;
	 IKEY_PRI <= 7'd0;
	 IKEY_VALUE <= 32'h00000000;
	 state_counter <= 8'd0;
	 ent_addr_fifo_init_done <= 1'b0;
	 ent_addr_fifo_init_addr <= 16'd0;
	 ent_addr_we <= 1'b0;
	 request_counter <= 8'd0;

	 O_ACK        <= 1'b0;
	 O_ENT_ERR    <= 1'b0;
	 O_SINGLE_HIT <= 1'b0;
	 O_MULTI_HIT <= 1'b0;
	 O_KEY_DAT    <= 128'd0;
	 O_EKEY_MSK   <= 128'd0;
	 O_KEY_PRI    <= 7'd0;
	 O_KEY_VALUE  <= 32'd0;

	 O_KERNEL_STATUS[7:0] <= 8'hFF;

      end else begin // if (XRST = 1'b0)

	 O_ENT_ERR    <= OENT_ERR;
	 O_SINGLE_HIT <= OSHIT;
	 O_MULTI_HIT <= OMHIT;
	 O_KEY_DAT    <= OKEY_DAT;
	 O_EKEY_MSK   <= OENT_ERR;
	 O_KEY_PRI    <= OKEY_PRI;
	 O_KEY_VALUE  <= OKEY_VALUE;
	 O_KERNEL_STATUS[7:0] <= state_counter;
	 O_ENT_ADDR <= OSRCH_ENT_ADD;

	 case(state_counter)
	   
	   8'd0: begin // wait for reset of ent_addr_fifo 
	      WAIT_FLAG <= 1'b1;
	      if(ent_addr_fifo_init_flag == 1'b1) begin
		 ent_addr_fifo_init_done <= 1'b0;
		 state_counter <= INTERNAL_INIT;
		 ent_addr_fifo_init_addr <= ent_addr_fifo_init_addr + 1;
		 ent_addr_we <= 1'b1;
		 ent_addr_din <= ent_addr_fifo_init_addr;
	      end
	   end
	   
	   INTERNAL_INIT: begin // init ent_addr_fifo
	      WAIT_FLAG <= 1'b1;
	      if(ent_addr_fifo_init_addr < 16'd65535) begin
		 ent_addr_fifo_init_done <= 1'b0;
		 ent_addr_fifo_init_addr <= ent_addr_fifo_init_addr + 1;
	      end else begin
		 ent_addr_fifo_init_done <= 1'b1;
		 state_counter <= MAIN_LOOP;
	      end
	      ent_addr_we <= 1'b1;
	      ent_addr_din <= ent_addr_fifo_init_addr;
	   end // case: INTERNAL_INIT
	   
	   MAIN_LOOP: begin // main state
	      WAIT_FLAG <= 1'b0;
	      ent_addr_we <= 1'b0;
	      ent_addr_din <= 16'd0;
	      O_ACK <= OACK;

	      if(cmd_valid == 1'b1 && cmd_search == 1'b1) begin
		 {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0001;
		 IKEY_DAT <= key_data;
		 IKEY_PRI <= key_pri;
		 IEKEY_MSK  <= ekey_msk;
		 IKEY_VALUE <= key_value;
		 request_counter = request_counter + 1; // block
	      end else if(cmd_valid == 1'b1 && cmd_write == 1'b1) begin
		 {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0000; // ICAM_WE will be asserted at next state
		 IKEY_DAT <= key_data;
		 IKEY_PRI <= key_pri;
		 IEKEY_MSK  <= ekey_msk;
		 IKEY_VALUE <= key_value;
		 IENT_ADD   <= ent_addr_q;
		 state_counter <= FLUSH_AND_OP_ADD;
	      end else if(cmd_valid == 1'b1 && cmd_erase == 1'b1) begin
		 {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0001;
		 IKEY_DAT <= key_data;
		 IKEY_PRI <= key_pri;
		 IEKEY_MSK  <= ekey_msk;
		 state_counter <= OP_ERASE;
		 request_counter = request_counter + 1; // block
	      end else if(cmd_valid == 1'b1 && cmd_update == 1'b1) begin
		 {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0001;
		 IKEY_DAT <= key_data;
		 IKEY_PRI <= key_pri;
		 IEKEY_MSK  <= ekey_msk;
		 IKEY_VALUE <= key_value;
		 state_counter <= OP_UPDATE;
		 request_counter = request_counter + 1; // block
	      end else if(cmd_valid == 1'b1) begin
		 // undefined operation
		 //{ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0000;
		 {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0001;
		 IKEY_DAT <= 128'd0;
		 IKEY_PRI <= 7'd0;
		 IEKEY_MSK  <= 128'd0;
		 request_counter = request_counter + 1; // block
	      end else begin
		 {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0000;
	      end
	      
	   end // case: MAIN_LOOP

	   WAIT_FOR_ACK: begin // wait ACK
	      WAIT_FLAG <= 1'b0;
	      ent_addr_we <= 1'b0;
	      ent_addr_din <= 16'd0;
	      {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0000;
	      if(OACK == 1'b1) begin
		 state_counter <= MAIN_LOOP;
	      end
	      O_ACK <= OACK;
	   end
	   
	   FLUSH_AND_OP_ADD: begin // wait ACK and write
	      if(request_counter == 8'd0) begin
	      	 {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0100;
		 request_counter = request_counter + 1; // block
		 state_counter <= WAIT_FOR_ACK;
	      end else begin
	      	 {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0000;
	      end
	      O_ACK <= OACK;
	   end
	   
	   OP_ERASE: begin // wait ACK and delete
	      WAIT_FLAG <= 1'b0;
	      if(OACK == 1'b1 && request_counter == 8'd1) begin
		 if(OENT_ERR == 1'b0 && (OSHIT == 1'b1 || OMHIT == 1'b1)) begin
		    {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b1000;
		    IENT_ADD <= OSRCH_ENT_ADD;
		    ent_addr_we <= 1'b1;
		    ent_addr_din <= OSRCH_ENT_ADD;
		    request_counter = request_counter + 1; // block
		    O_ACK <= 1'b0; // this OACK consumes only for erase interanl
		    state_counter <= WAIT_FOR_ACK;
		 end else begin
		    ent_addr_we <= 1'b0;
		    ent_addr_din <= 16'h0;
		    O_ACK <= 1'b1; // nothing to erase
		    state_counter <= MAIN_LOOP;
		 end
	      end else begin
		 {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0000;
		 O_ACK <= OACK;
		 ent_addr_we <= 1'b0;
		 ent_addr_din <= 16'h0;
	      end
	   end
	   
	   OP_UPDATE: begin // wait ACK and update
	      WAIT_FLAG <= 1'b0;
	      ent_addr_we <= 1'b0;
	      if(OACK == 1'b1 && request_counter == 8'd1) begin
		 if(OENT_ERR == 1'b0 && (OSHIT == 1'b1 || OMHIT == 1'b1)) begin
		    // update the found entry
		    IENT_ADD <= OSRCH_ENT_ADD;
		    {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b1100;
		 end else begin
		    // nothing to update, instead write
		    IENT_ADD <= ent_addr_q;
	      	    {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0100;
		 end
		 IKEY_DAT   <= IKEY_DAT;
		 IKEY_PRI   <= IKEY_PRI;
		 IEKEY_MSK  <= IEKEY_MSK;
		 IKEY_VALUE <= IKEY_VALUE;
		 request_counter = request_counter + 1; // block
		 O_ACK <= 1'b0; // this OACK consumes only for update interanl
		 state_counter <= WAIT_FOR_ACK;
	      end else begin
		 {ICAM_IE, ICAM_WE, ICAM_RE, ICAM_SE} <= 4'b0000;
		 O_ACK <= OACK;
	      end
	   end // case: OP_UPDATE

	   default: begin
	      state_counter <= MAIN_LOOP;
	   end

	 endcase // case (state_counter)

	 if(OACK == 1'b1) begin
	    request_counter = request_counter - 1; // block
	 end
	 
      end // else: !if(XRST = 1'b0)
      
   end // always @ (posedge ICLK)


   always_comb begin
      if(state_counter == MAIN_LOOP && cmd_valid == 1'b1) begin
	 cmd_rd <= 1'b1;
      end else begin
	 cmd_rd <= 1'b0;
      end
   end

   always_comb begin
      if((state_counter == MAIN_LOOP && cmd_valid == 1'b1 && cmd_write == 1'b1) ||
	 (state_counter == OP_UPDATE && OACK == 1'b1 && request_counter == 8'd1 && OSHIT == 1'b0 && OMHIT == 1'b0)
	 ) begin
	 ent_addr_rd <= 1'b1;
      end else begin
	 ent_addr_rd <= 1'b0;
      end
   end
   
endmodule // axonerve_kvs_kernel

`default_nettype wire
