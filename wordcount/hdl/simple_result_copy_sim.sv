`default_nettype none

module simple_result_copy_sim();

   logic clk = 0;
   logic reset;
   logic kick;
   logic busy;
   logic [31:0] offset;
   logic [31:0] words;
   logic [64-1:0] memory_addr;

   logic [31:0]   addr;
   logic [64-1:0] q = 64'h11111111_11111111;

   logic 	  ctrl_start;
   logic 	  ctrl_done;
   logic [64-1:0] ctrl_addr_offset;
   logic [64-1:0] ctrl_xfer_size_in_bytes;
   logic 	  m_axis_tvalid;
   logic 	  m_axis_tready;
   logic [512-1:0] m_axis_tdata;

   initial begin
      clk <= 1'b0;
      forever begin
	 clk <= ~clk;
	 #5;
      end
   end

   logic [31:0] counter = 32'h0;
       
   always @(posedge clk) begin
      
      case(counter)

	0: begin
	   reset <= 1'b1;
	   kick <= 1'b0;
	   counter <= counter + 1;
	end

	10: begin
	   reset <= 'b0;
	   counter <= counter + 1;
	end

	20: begin
	   kick <= 1'b1;
	   offset <= 32'd0;
	   words <= 32'd2048;
	   memory_addr <= 64'habadcafe_deadbeef;
	   m_axis_tready <= 1;
	   counter <= counter + 1;
	end

	21: begin
	   kick <= 0;
	   if(busy == 0 && kick == 0) begin
	      counter <= counter + 1;
	   end
	end

	22: begin
	   $finish;
	end

	default: begin
	   counter <= counter + 1;
	end

      endcase // case (counter)

   end // always @ (posedge clk)

   always @(posedge clk) begin
      q <= q + 1;
      if(ctrl_start == 1) begin
	 ctrl_done <= 1;
      end else begin
	 ctrl_done <= 0;
      end
   end

   simple_result_copy
     dut (
	  .clk(clk),
	  .reset(reset),

	  .kick(kick),
	  .busy(busy),
	  .offset(offset),
	  .words(words),
	  .memory_addr(memory_addr),

	  .addr(addr),
	  .q(q),

	  .ctrl_start(ctrl_start),
	  .ctrl_done(ctrl_done),
	  .ctrl_addr_offset(ctrl_addr_offset),
	  .ctrl_xfer_size_in_bytes(ctrl_xfer_size_in_bytes),
	  .m_axis_tvalid(m_axis_tvalid),
	  .m_axis_tready(m_axis_tready),
	  .m_axis_tdata(m_axis_tdata)
	  );

endmodule // simple_result_copy_sim

`default_nettype wire
