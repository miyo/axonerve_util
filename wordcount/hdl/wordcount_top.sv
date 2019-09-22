`default_nettype none

module wordcout_top
  (
   input wire 		 clk,
   input wire 		 reset,
  
   input wire 		 kick,
   output wire 		 busy,

   // scalar parameters
   input wire [31:0] 	 command,
   input wire [31:0] 	 num_of_words,
   input wire [64-1:0] 	 global_memory_offset,
  
   // to/from axonerve_kvs_rtl_example_axi_read_master
   output wire 		 reader_ctrl_start,
   input wire 		 reader_ctrl_done,
   output wire [64-1:0]  reader_ctrl_addr_offset,
   output wire [64-1:0]  reader_ctrl_xfer_size_in_bytes,
   input wire 		 reader_s_axis_tvalid,
   output wire 		 reader_s_axis_tready,
   input wire [512-1:0]  reader_s_axis_tdata,
   input wire 		 reader_s_axis_tlast,
  
   // to/from axonerve_kvs_rtl_example_axi_write_master
   output wire 		 writer_ctrl_start,
   input wire 		 writer_ctrl_done,
   output wire [64-1:0]  writer_ctrl_addr_offset,
   output wire [64-1:0]  writer_ctrl_xfer_size_in_bytes,
   output wire 		 writer_m_axis_tvalid,
   input wire 		 writer_m_axis_tready,
   output wire [512-1:0] writer_m_axis_tdata
   );
   
   logic 		 search_and_add_kick;
   logic 		 search_and_add_busy;
   logic [31:0] 	 search_and_add_num_of_words;
   logic 		 axonerve_ready;
   logic [63:0] 	 search_and_add_memory_offset;
   
   logic [31:0] 	 search_and_add_accum_addr;
   logic [63:0] 	 search_and_add_accum_din;
   logic [0:0] 		 search_and_add_accum_we;

   logic [31:0] 	 accum_addr;
   logic [63:0] 	 accum_din;
   logic [0:0] 		 accum_we;
   logic [63:0] 	 accum_q;

   logic 		 result_copy_kick;
   logic 		 result_copy_busy;
   logic [31:0] 	 result_copy_offset;
   logic [31:0] 	 result_copy_words;
   logic [63:0] 	 result_copy_memory_offset;

   logic [31:0] 	 result_copy_addr;
   logic [63:0] 	 result_copy_q;

   logic [31:0] 	 command_reg;

   logic 		 top_busy;
   logic [7:0] 		 state_counter = 0;

   always_ff @(posedge clk) begin
      if(reset == 1) begin
	 search_and_add_kick <= 0;
	 result_copy_kick <= 0;
	 top_busy <= 0;
	 state_counter <= 'd0;
      end else begin
	 case(state_counter)
	   0: begin
	      if(axonerve_ready == 1) begin
		 state_counter <= state_counter + 1;
	      end
	   end
	   1: begin
	      if(kick == 1) begin
		 top_busy <= 1;
		 command_reg <= command;
		 state_counter <= state_counter + 1;
		 if(command == 1) begin
		    search_and_add_kick <= 1;
		    search_and_add_num_of_words <= num_of_words;
		    search_and_add_memory_offset <= global_memory_offset;
		    result_copy_kick <= 0;
		 end else if(command == 2) begin
		    result_copy_kick <= 1;
		    result_copy_offset <= 0;
		    result_copy_words <= num_of_words;
		    result_copy_memory_offset <= global_memory_offset;
		    search_and_add_kick <= 0;
		 end else begin
		    search_and_add_kick <= 0;
		    result_copy_kick <= 0;
		 end
	      end else begin // if (kick == 1)
		 top_busy <= 0;
		 search_and_add_kick <= 0;
		 result_copy_kick <= 0;
	      end // else: !if(kick == 1)
	   end // case: 1
	   
	   2: begin
	      search_and_add_kick <= 0;
	      result_copy_kick <= 0;
	      if(~(search_and_add_busy || result_copy_busy || result_copy_kick || search_and_add_kick)) begin
		 state_counter <= 'd1;
		 top_busy <= 0;
	      end
	   end

	   default: begin
	      state_counter <= 'd0;
	   end
	   
	 endcase // case (state_counter)
	 
      end // else: !if(reset == 1)
   end // always_ff @ (posedge clk)
   

   assign busy = ~(axonerve_ready) || search_and_add_busy || result_copy_busy || top_busy;
   assign accum_addr = command_reg == 1 ? search_and_add_accum_addr :
		       command_reg == 2 ? result_copy_addr :
		       0;
   assign accum_we = command_reg == 1 ? search_and_add_accum_we[0] :
		     0;
   assign accum_din = command_reg == 1 ? search_and_add_accum_din :
		      0;
   assign result_copy_q = accum_q;

   search_and_add_ctrl #(.MAX_WORDS(16))
   search_and_add_ctrl_i
     (
      .clk(clk),
      .reset(reset),
      
      .kick(search_and_add_kick),
      .busy(search_and_add_busy),
      .num_of_words(search_and_add_num_of_words),
      .memory_offset(search_and_add_memory_offset),
      .axonerve_ready(axonerve_ready),
      
      // to/from axonerve_kvs_rtl_example_axi_read_master
      .ctrl_start(reader_ctrl_start),
      .ctrl_done(reader_ctrl_done),
      .ctrl_addr_offset(reader_ctrl_addr_offset),
      .ctrl_xfer_size_in_bytes(reader_ctrl_xfer_size_in_bytes),
      .m_axis_tvalid(reader_s_axis_tvalid),
      .m_axis_tready(reader_s_axis_tready),
      .m_axis_tdata(reader_s_axis_tdata),
      .m_axis_tlast(reader_s_axis_tlast),
      
      // output to accum_array
      .accum_addr(search_and_add_accum_addr),
      .accum_din(search_and_add_accum_din),
      .accum_we(search_and_add_accum_we[0])
      );

   accum_array #(.ADDR_WIDTH(14))
   accum_array_i
     (
      .clk(clk),
      .reset(reset),
      
      .addr(accum_addr),
      .din(accum_din),
      .we(accum_we),
      .q(accum_q)
      );

   simple_result_copy
     simple_result_copy_i
       (
	.clk(clk),
	.reset(reset),
       
	.kick(result_copy_kick),
	.busy(result_copy_busy),
	.offset(result_copy_offset),
	.words(result_copy_words),
	.memory_addr(result_copy_memory_offset),

	.addr(result_copy_addr),
	.q(result_copy_q),

	.ctrl_start(writer_ctrl_start),
	.ctrl_done(writer_ctrl_done),
	.ctrl_addr_offset(writer_ctrl_addr_offset),
	.ctrl_xfer_size_in_bytes(writer_ctrl_xfer_size_in_bytes),
	.m_axis_tvalid(writer_m_axis_tvalid),
	.m_axis_tready(writer_m_axis_tready),
	.m_axis_tdata(writer_m_axis_tdata)
	);

endmodule // search_and_add_ctrl

`default_nettype wire
