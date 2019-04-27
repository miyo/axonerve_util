module axonerve_kvs_kernel_sim ( );
		     
   logic I_CLK = 1'b0;
   logic I_CLKX2 = 1'b0;
   logic I_XRST = 1'b0;
   
   logic [31:0] O_VERSION;
   logic 	O_READY;
   logic 	O_WAIT;

   logic 	O_ACK;
   logic 	O_ENT_ERR;
   logic 	O_SINGLE_HIT;
   logic 	O_MULTIL_HIT;
   logic [127:0] O_KEY_DAT;
   logic [127:0] O_EKEY_MSK;
   logic [6:0] 	 O_KEY_PRI;
   logic [31:0]  O_KEY_VALUE;
   logic 	 O_CMD_EMPTY;
   logic 	 O_CMD_FULL;
   logic 	 O_ENT_FULL;

   logic 	 I_CMD_INIT = 1'b0;
   logic 	 I_CMD_VALID = 1'b0;
   logic  	 I_CMD_ERASE = 1'b0;
   logic 	 I_CMD_WRITE = 1'b0;
   logic 	 I_CMD_READ = 1'b0;
   logic 	 I_CMD_SEARCH = 1'b0;
   logic 	 I_CMD_UPDATE = 1'b0;
   logic [127:0] I_KEY_DAT = 128'd0;
   logic [127:0] I_EKEY_MSK = 128'd0;
   logic [6:0] 	 I_KEY_PRI = 7'd0;
   logic [31:0]  I_KEY_VALUE = 32'd0;

   axonerve_kvs_kernel u(
		  .I_CLK(I_CLK),
		  .I_CLKX2(I_CLKX2),
		  .I_XRST(I_XRST),
		  .O_VERSION(O_VERSION),
		  .O_READY(O_READY),
		  .O_WAIT(O_WAIT),

		  .O_ACK(O_ACK),
		  .O_ENT_ERR(O_ENT_ERR),
		  .O_SINGLE_HIT(O_SINGLE_HIT),
		  .O_MULTIL_HIT(O_MULTIL_HIT),
		  .O_KEY_DAT(O_KEY_DAT),
		  .O_EKEY_MSK(O_EKEY_MSK),
		  .O_KEY_PRI(O_KEY_PRI),
		  .O_KEY_VALUE(O_KEY_VALUE),
		  .O_CMD_EMPTY(O_CMD_EMPTY),
		  .O_CMD_FULL(O_CMD_FULL),
		  .O_ENT_FULL(O_ENT_FULL),

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
   
   initial begin
      I_CLK = 1'b0;
      forever #10 I_CLK = ~I_CLK; // generate a clock
   end
   
   initial begin
      I_CLKX2 = 1'b0;
      forever #5 I_CLKX2 = ~I_CLKX2; // generate a clock
   end

   logic [31:0] ack_count = 32'd0;
   always @(posedge I_CLK) begin
      if(O_ACK == 1'b1) begin
	 ack_count <= ack_count + 1;
      end
   end
   

   logic [31:0] counter = 32'd0;

   always @(posedge I_CLK) begin
      
      case (counter)
	
	32'd0: begin // reset
	   I_XRST <= 1'b0;
	   counter <= counter + 1;
	   I_CMD_INIT <= 1'b0;
	   I_CMD_VALID <= 1'b0;
	   I_CMD_ERASE <= 1'b0;
	   I_CMD_WRITE <= 1'b0;
	   I_CMD_READ <= 1'b0;
	   I_CMD_SEARCH <= 1'b0;
	   I_CMD_UPDATE <= 1'b0;
	end
	
	32'd10: begin // deassert reset
	   I_XRST <= 1'b1;
	   if(O_READY == 1'b1) begin
	      counter <= counter + 1;
	   end
	end

	32'd20: begin // write
	   counter <= counter + 1;
	   I_CMD_VALID <= 1'b1;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b01000;
	   I_KEY_DAT <= 128'h_abadcafe_abadcafe_abadcafe_abadcafe;
	   I_EKEY_MSK <= 128'd0;
	   I_KEY_PRI <= 7'd0;
	   I_KEY_VALUE <= 32'h_34343434;
	end
	32'd21: begin // search
	   counter <= counter + 1;
	   I_CMD_VALID <= 1'b1;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b00010;
	   I_KEY_DAT <= 128'h_abadcafe_abadcafe_abadcafe_abadcafe;
	   I_EKEY_MSK <= 128'd0;
	   I_KEY_PRI <= 7'd0;
	   I_KEY_VALUE <= 32'h_34343434;
	end
	32'd22: begin // write
	   counter <= counter + 1;
	   I_CMD_VALID <= 1'b1;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b01000;
	   I_KEY_DAT <= 128'h_deadbeef_deadbeef_deadbeef_deadbeef;
	   I_EKEY_MSK <= 128'd0;
	   I_KEY_PRI <= 7'd0;
	   I_KEY_VALUE <= 32'h_a5a5a5a5;
	end
	32'd23: begin // search
	   counter <= counter + 1;
	   I_CMD_VALID <= 1'b1;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b00010;
	   I_KEY_DAT <= 128'h_abadcafe_abadcafe_abadcafe_abadcafe;
	   I_EKEY_MSK <= 128'd0;
	   I_KEY_PRI <= 7'd0;
	   I_KEY_VALUE <= 32'h_34343434;
	end
	32'd24: begin // search
	   counter <= counter + 1;
	   I_CMD_VALID <= 1'b1;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b00010;
	   I_KEY_DAT <= 128'h_deadbeef_deadbeef_deadbeef_deadbeef;
	   I_EKEY_MSK <= 128'd0;
	   I_KEY_PRI <= 7'd0;
	   I_KEY_VALUE <= 32'h_34343434;
	end
	32'd25: begin // update
	   counter <= counter + 1;
	   I_CMD_VALID <= 1'b1;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b00001;
	   I_KEY_DAT <= 128'h_abadcafe_abadcafe_abadcafe_abadcafe;
	   I_EKEY_MSK <= 128'd0;
	   I_KEY_PRI <= 7'd0;
	   I_KEY_VALUE <= 32'h_fefefefe;
	end
	32'd26: begin // search
	   counter <= counter + 1;
	   I_CMD_VALID <= 1'b1;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b00010;
	   I_KEY_DAT <= 128'h_abadcafe_abadcafe_abadcafe_abadcafe;
	   I_EKEY_MSK <= 128'd0;
	   I_KEY_PRI <= 7'd0;
	   I_KEY_VALUE <= 32'h_34343434;
	end
	32'd27: begin // search
	   counter <= counter + 1;
	   I_CMD_VALID <= 1'b1;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b00010;
	   I_KEY_DAT <= 128'h_deadbeef_deadbeef_deadbeef_deadbeef;
	   I_EKEY_MSK <= 128'd0;
	   I_KEY_PRI <= 7'd0;
	   I_KEY_VALUE <= 32'h_34343434;
	end
	32'd28: begin // erase
	   counter <= counter + 1;
	   I_CMD_VALID <= 1'b1;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b10000;
	   I_KEY_DAT <= 128'h_abadcafe_abadcafe_abadcafe_abadcafe;
	   I_EKEY_MSK <= 128'd0;
	   I_KEY_PRI <= 7'd0;
	   I_KEY_VALUE <= 32'h_fefefefe;
	end
	32'd29: begin // search
	   counter <= counter + 1;
	   I_CMD_VALID <= 1'b1;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b00010;
	   I_CMD_SEARCH <= 1'b1;
	   I_KEY_DAT <= 128'h_abadcafe_abadcafe_abadcafe_abadcafe;
	   I_EKEY_MSK <= 128'd0;
	   I_KEY_PRI <= 7'd0;
	   I_KEY_VALUE <= 32'h_34343434;
	end
	32'd30: begin // search
	   counter <= counter + 1;
	   I_CMD_VALID <= 1'b1;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b00010;
	   I_KEY_DAT <= 128'h_deadbeef_deadbeef_deadbeef_deadbeef;
	   I_EKEY_MSK <= 128'd0;
	   I_KEY_PRI <= 7'd0;
	   I_KEY_VALUE <= 32'h_34343434;
	end

	default : begin
	   counter <= counter + 1;
	   I_CMD_INIT <= 1'b0;
	   I_CMD_VALID <= 1'b0;
	   {I_CMD_ERASE, I_CMD_WRITE, I_CMD_READ, I_CMD_SEARCH, I_CMD_UPDATE} <= 5'b00000;
	end

      endcase // case (counter)
      
   end

   

endmodule // axonerve_kvs_kernel_sim
