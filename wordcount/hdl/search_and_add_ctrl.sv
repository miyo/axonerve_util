`default_nettype none

module search_and_add_ctrl
  #(
    parameter integer MAX_WORDS = 16,
    parameter integer READ_PAGESIZE = 4096
    )
   (
    input wire 		 clk,
    input wire 		 reset,
   
    input wire 		 kick,
    output wire 	 busy,
    input wire [31:0] 	 num_of_words,
    input wire [64-1:0]  memory_offset,
    output wire 	 axonerve_ready,
   
    // to/from axonerve_kvs_rtl_example_axi_read_master
    output wire 	 ctrl_start,
    input wire 		 ctrl_done,
    output wire [64-1:0] ctrl_addr_offset,
    output wire [32-1:0] ctrl_xfer_size_in_bytes,
    input wire 		 m_axis_tvalid,
    output wire 	 m_axis_tready,
    input wire [512-1:0] m_axis_tdata,
    input wire 		 m_axis_tlast,
   
    // output to accum_array
    output wire [31:0] 	 accum_addr,
    output wire [63:0] 	 accum_din,
    output wire 	 accum_we
    );
   
   logic 		 ctrl_start_reg;
   logic [64-1:0] 	 ctrl_addr_offset_reg;
   logic [32-1:0] 	 ctrl_xfer_size_in_bytes_reg;

   assign ctrl_start = ctrl_start_reg;
   assign ctrl_addr_offset = ctrl_addr_offset_reg;
   assign ctrl_xfer_size_in_bytes = ctrl_xfer_size_in_bytes_reg;

   logic 		 search_and_add_kick;
   logic 		 search_and_add_busy;
   logic [128+32-1:0] 	 search_and_add_din;
   logic 		 search_and_add_we;
   logic 		 search_and_add_full;
   logic [7:0] 		 search_and_add_data_num;
   
   logic 		 conv_buf_full;
   logic 		 conv_buf_rd;
   logic 		 conv_buf_valid;
   logic [512-1:0] 	 conv_buf_dout;

   logic [31:0] 	 data_counter;
   logic [7:0] 		 state_counter;
   logic 		 busy_reg;
   
   logic [31:0] 	 num_of_words_reg;
   logic [64-1:0] 	 memory_offset_reg;
   logic [31:0] 	 target_words;
   
   logic [512-1-128:0] 	 conv_buf_reg;

   logic [7:0] 		 input_counter;
   
   assign busy = busy_reg;

   logic [31:0] 	 read_rest_bytes;
   logic 		 conv_buf_reset;
  
   always_ff @(posedge clk) begin
      if(reset == 1) begin
	 state_counter <= 0;
	 busy_reg <= 0;
	 search_and_add_kick <= 0;
	 ctrl_start_reg <= 0;
	 conv_buf_reset <= 1;
      end else begin

	 case(state_counter)
	   0: begin
	      if(kick == 1)begin
		 busy_reg <= 1;
		 num_of_words_reg <= num_of_words;
		 memory_offset_reg <= memory_offset;
		 state_counter <= state_counter + 1;
	      end else begin
		 busy_reg <= 0;
	      end
	      ctrl_start_reg <= 0;
	      data_counter <= 0;
	      search_and_add_we <= 0;
	      search_and_add_kick <= 0;
	      input_counter <= 0;
	      read_rest_bytes <= 0;
	      conv_buf_reset <= 0;
	   end

	   1: begin // kick axi_reader
	      search_and_add_we <= 0;
	      if(num_of_words_reg > 0) begin
		 
		 if(read_rest_bytes == 0) begin // should read next data from AXI
		    ctrl_start_reg <= 1;
		    ctrl_xfer_size_in_bytes_reg <= READ_PAGESIZE; // pagesize = 4KB
		    ctrl_addr_offset_reg <= memory_offset_reg;
		    memory_offset_reg <= memory_offset_reg + READ_PAGESIZE;
		    read_rest_bytes <= READ_PAGESIZE;
		 end else begin // fifo has data
		    // nothing to do
		 end
		 
		 state_counter <= state_counter + 1;
		 
		 if(num_of_words_reg > MAX_WORDS) begin
		    target_words <= MAX_WORDS;
		    num_of_words_reg <= num_of_words_reg - MAX_WORDS;
		 end else begin
		    target_words <= num_of_words_reg;
		    num_of_words_reg <= 0;
		 end
		 
	      end else begin
		 ctrl_start_reg <= 0;
		 state_counter <= 0; // wait for next request
		 conv_buf_reset <= 1; // reset before wating for next request
	      end
	   end // case: 1
	   
	   2: begin // read data from FIFO
	      ctrl_start_reg <= 0; // de-assert ctrl_start
	      if(conv_buf_valid == 1) begin
		 read_rest_bytes <= read_rest_bytes - 64; // consumed 64bytes(=512bit)
		 conv_buf_reg <= conv_buf_dout[511:128];
		 search_and_add_din <= {data_counter, conv_buf_dout[127:0]};
		 search_and_add_we <= 1;
		 input_counter <= input_counter + 1;
		 data_counter <= data_counter + 1;
		 target_words <= target_words - 1;
		 if(target_words == 1) begin
		    state_counter <= 6;
		 end else begin
		    state_counter <= state_counter + 1;
		 end
	      end else begin
		 search_and_add_we <= 0;
	      end
	      
	   end // case: 2
	   
	   3:begin
	      conv_buf_reg <= {128'd0, conv_buf_reg[383:128]};
	      search_and_add_din <= {data_counter, conv_buf_reg[127:0]};
	      search_and_add_we <= 1;
	      input_counter <= input_counter + 1;
	      data_counter <= data_counter + 1;
	      state_counter <= state_counter + 1;
	      target_words <= target_words - 1;
	      if(target_words == 1) begin
		 state_counter <= 6;
	      end else begin
		 state_counter <= state_counter + 1;
	      end
	   end
	   
	   4:begin
	      conv_buf_reg <= {128'd0, conv_buf_reg[383:128]};
	      search_and_add_din <= {data_counter, conv_buf_reg[127:0]};
	      search_and_add_we <= 1;
	      input_counter <= input_counter + 1;
	      data_counter <= data_counter + 1;
	      state_counter <= state_counter + 1;
	      target_words <= target_words - 1;
	      if(target_words == 1) begin
		 state_counter <= 6;
	      end else begin
		 state_counter <= state_counter + 1;
	      end
	   end
	   
	   5:begin
	      conv_buf_reg <= {128'd0, conv_buf_reg[383:128]};
	      search_and_add_din <= {data_counter, conv_buf_reg[127:0]};
	      search_and_add_we <= 1;
	      input_counter <= input_counter + 1;
	      data_counter <= data_counter + 1;
	      state_counter <= 2;
	      target_words <= target_words - 1;
	      if(target_words == 1) begin
		 state_counter <= 6;
	      end else begin
		 state_counter <= 2;
	      end
	   end
	   
	   6:begin
	      search_and_add_we <= 0;
	      search_and_add_kick <= 1;
	      search_and_add_data_num <= input_counter;
	      input_counter <= 0;
	      state_counter <= state_counter + 1;
	   end

	   7: begin
	      search_and_add_kick <= 0;
	      if(search_and_add_kick == 0 && search_and_add_busy == 0) begin
		 state_counter <= 1;
	      end
	   end

	   default: begin
	      state_counter <= 0;
	      conv_buf_reset <= 1; // reset before wating for next request
	   end
	   
	 endcase
	 
      end
   end
   
   fifo_512_512_ft conv_buf
     (.clk(clk),
      .srst(conv_buf_reset),
      .din(m_axis_tdata),
      .wr_en(m_axis_tvalid),
      .full(),
      .empty(),
      .prog_full(conv_buf_full),
      .rd_en(conv_buf_rd),
      .dout(conv_buf_dout),
      .valid(conv_buf_valid),
      .wr_rst_busy(),
      .rd_rst_busy()
      );
   assign conv_buf_rd = (conv_buf_valid == 1 && state_counter == 2) ? 1 : 0;
   assign m_axis_tready = ~conv_buf_full;

   logic ready;
   assign axonerve_ready = ready;
   
   search_and_add u
     (.clk(clk),
      .reset(reset),
      .ready(ready),
      
      .kick(search_and_add_kick),
      .busy(search_and_add_busy),
      .data_num(search_and_add_data_num),
      
      .din(search_and_add_din),
      .we(search_and_add_we),
      .full(search_and_add_full),

      .accum_addr(accum_addr),
      .accum_din(accum_din),
      .accum_we(accum_we)
      );

endmodule // search_and_add_ctrl

`default_nettype wire
