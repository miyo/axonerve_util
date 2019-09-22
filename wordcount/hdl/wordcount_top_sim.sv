`default_nettype none

module wordcout_top_sim ();

   logic clk = 1'b0;
   logic reset = 1'b0;

   logic kick = 1'b0;
   logic busy;

   // scalar parameters
   logic [31:0] command;
   logic [31:0] num_of_words;
   logic [64-1:0] global_memory_offset;
   
   // to/from axonerve_kvs_rtl_example_axi_read_master
   logic 	  reader_ctrl_start;
   logic 	  reader_ctrl_done;
   logic [64-1:0] reader_ctrl_addr_offset;
   logic [64-1:0] reader_ctrl_xfer_size_in_bytes;
   logic 	  reader_s_axis_tvalid;
   logic 	  reader_s_axis_tready;
   logic [512-1:0] reader_s_axis_tdata;
   logic	   reader_s_axis_tlast;
   
   // to/from axonerve_kvs_rtl_example_axi_write_master
   logic 	   writer_ctrl_start;
   logic 	   writer_ctrl_done;
   logic [64-1:0]  writer_ctrl_addr_offset;
   logic [64-1:0]  writer_ctrl_xfer_size_in_bytes;
   logic 	   writer_m_axis_tvalid;
   logic 	   writer_m_axis_tready;
   logic [512-1:0] writer_m_axis_tdata;
			 

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
	   if(busy == 0) begin
	      counter <= counter + 1;
	   end
	end
	
	22: begin
	   kick <= 1'b1;
	   command <= 'd1;
	   num_of_words = 128;
	   global_memory_offset = {32'h00000000, 32'h80000000};
	   counter <= counter + 1;
	end

	23: begin
	   kick <= 0;
	   if(busy == 0) begin
	      counter <= counter + 1;
	   end
	end

	24: begin
	   $finish;
	end
	
	default: begin
	   counter <= counter + 1;
	   kick <= 1'b0;
	end
	
      endcase
      
   end
   
   assign reader_s_axis_tvalid = 1;
   assign reader_s_axis_tdata = { 32'h01234567, 32'h89abcdef, 32'h01234567, 32'h89abcdef,
				  32'hdeadbeef, 32'hdeadbeef, 32'hdeadbeef, 32'hdeadbeef,
				  32'habadcafe, 32'habadcafe, 32'habadcafe, 32'habadcafe,
				  32'h11c0ffee, 32'h11c0ffee, 32'h11c0ffee, 32'h11c0ffee };
   assign reader_s_axis_tlast = 1;

   wordcout_top dut(
		    .clk(clk),
		    .reset(reset),
   
		    .kick(kick),
		    .busy(busy),

		    // scalar parameters
		    .command(command),
		    .num_of_words(num_of_words),
		    .global_memory_offset(global_memory_offset),
   
		    // to/from axonerve_kvs_rtl_example_axi_read_master
		    .reader_ctrl_start(reader_ctrl_start),
		    .reader_ctrl_done(reader_ctrl_done),
		    .reader_ctrl_addr_offset(reader_ctrl_addr_offset),
		    .reader_ctrl_xfer_size_in_bytes(reader_ctrl_xfer_size_in_bytes),
		    .reader_s_axis_tvalid(reader_s_axis_tvalid),
		    .reader_s_axis_tready(reader_s_axis_tready),
		    .reader_s_axis_tdata(reader_s_axis_tdata),
		    .reader_s_axis_tlast(reader_s_axis_tlast),
   
		    // to/from axonerve_kvs_rtl_example_axi_write_master
		    .writer_ctrl_start(writer_ctrl_start),
		    .writer_ctrl_done(writer_ctrl_done),
		    .writer_ctrl_addr_offset(writer_ctrl_addr_offset),
		    .writer_ctrl_xfer_size_in_bytes(writer_ctrl_xfer_size_in_bytes),
		    .writer_m_axis_tvalid(writer_m_axis_tvalid),
		    .writer_m_axis_tready(writer_m_axis_tready),
		    .writer_m_axis_tdata(writer_m_axis_tdata)
		    );


endmodule // search_and_add_ctrl_sim

`default_nettype wire
