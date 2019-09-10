`default_nettype none

module search_and_add_ctrl_sim ();

   logic clk = 1'b0;
   logic reset;

   logic           kick;
   logic           busy;
   logic [31:0]    num_of_words;
   logic [64-1:0]  memory_offset;
   logic 	   axonerve_ready;

   logic 	   ctrl_start;
   logic 	   ctrl_done;
   logic [64-1:0]  ctrl_addr_offset;
   logic [64-1:0]  ctrl_xfer_size_in_bytes;
   logic 	   m_axis_tvalid;
   logic 	   m_axis_tready;
   logic [512-1:0] m_axis_tdata;
   logic 	   m_axis_tlast;

   logic [31:0] accum_addr;
   logic [63:0] accum_din;
   logic        accum_we;

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
	   reset = 1'b1;
	   kick <= 1'b0;
	   counter <= counter + 1;
	end

	10: begin
	   reset = 1'b0;
	   counter <= counter + 1;
	end

	20: begin
	   if(axonerve_ready == 1) begin
	      counter <= counter + 1;
	   end
	end
	
	22: begin
	   kick <= 1'b1;
	   num_of_words = 128;
	   memory_offset = {32'h00000000, 32'h80000000};
	end			    
	
	default: begin
	   counter <= counter + 1;
	   kick <= 1'b0;
	end
	
      endcase
      
   end
   
   assign m_axis_tvalid = 1;
   assign m_axis_tdata = { 32'h01234567, 32'h89abcdef, 32'h01234567, 32'h89abcdef,
                           32'hdeadbeef, 32'hdeadbeef, 32'hdeadbeef, 32'hdeadbeef,
                           32'habadcafe, 32'habadcafe, 32'habadcafe, 32'habadcafe,
                           32'h11c0ffee, 32'h11c0ffee, 32'h11c0ffee, 32'h11c0ffee };
   assign m_axis_tlast = 1;

   search_and_add_ctrl DUT (
			    .clk(clk),
			    .reset(reset),
			    
			    .kick(kick),
			    .busy(busy),
			    .num_of_words(num_of_words),
			    .memory_offset(memory_offset),
			    .axonerve_ready(axonerve_ready),
			    
			    .ctrl_start(ctrl_start),
			    .ctrl_done(ctrl_done),
			    .ctrl_addr_offset(ctrl_addr_offset),
			    .ctrl_xfer_size_in_bytes(ctrl_xfer_size_in_bytes),
			    .m_axis_tvalid(m_axis_tvalid),
			    .m_axis_tready(m_axis_tready),
			    .m_axis_tdata(m_axis_tdata),
			    .m_axis_tlast(m_axis_tlast),
			    
			    .accum_addr(accum_addr),
			    .accum_din(accum_din),
			    .accum_we(accum_we)
			    );

endmodule // search_and_add_ctrl_sim

`default_nettype wire
