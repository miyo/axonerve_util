`default_nettype none

module simple_result_copy(
       input wire 	      clk,
       input wire 	      reset,

       input wire 	      kick,
       output logic 	      busy,
       input wire [31:0]      offset,
       input wire [31:0]      words,
       input wire [64-1:0]    memory_addr,

       output logic [31:0]    addr,
       input wire [64-1:0]    q,

       output logic 	      ctrl_start,
       input wire 	      ctrl_done,
       output logic [64-1:0]  ctrl_addr_offset,
       output logic [64-1:0]  ctrl_xfer_size_in_bytes,
       output logic 	      m_axis_tvalid,
       input wire 	      m_axis_tready,
       output logic [512-1:0] m_axis_tdata
       );

   localparam MAX_WORDS_NUM = 512;

   logic [511:0] 	     buf_din;
   logic 		     buf_we;
   logic 		     buf_full;

   logic [7:0] 		     state_counter;
   logic [31:0] 	     offset_reg;
   logic [31:0] 	     words_reg;
   logic [31:0] 	     word_counter;

   logic [31:0] 	     target_words;

   logic [64-1:0] 	     memory_addr_reg;

   always_ff @(posedge clk) begin
      if(reset == 1) begin
	 busy <= 1;
	 state_counter <= 0;
	 ctrl_start <= 0;
	 buf_we <= 0;
      end else

	case(state_counter)
	  0 : begin
	     if(kick == 1) begin
		state_counter <= state_counter + 1;
		busy <= 1;
		if(words[2:0] == 0) begin
		   words_reg <= words;
		end else begin
		   words_reg[31:3] <= words[31:3] + 1;
		   words_reg[2:0] <= 0;
		end
		if(words < MAX_WORDS_NUM) begin
		   if(words[2:0] == 0) begin
		      target_words <= words;
		   end else begin
		      target_words[31:3] <= words[31:3] + 1;
		      target_words[2:0] <= 0;
		   end
		end else begin
		   target_words <= MAX_WORDS_NUM;
		end
		memory_addr_reg <= memory_addr;
		offset_reg <= offset;
		addr <= offset;
		word_counter <= 0;
	     end else begin
		busy <= 0;
	     end
	  end // case: 0

	  1: begin
	     addr <= addr + 1;
	     state_counter <= state_counter + 1;
	  end

	  2: begin
	     addr <= addr + 1;
	     if(word_counter[2:0] == 7) begin
		buf_we <= 1;
	     end else begin
		buf_we <= 0;
	     end
	     buf_din <= {q, buf_din[512-1:64]};
	     if(word_counter + 1 == target_words) begin
		state_counter <= state_counter + 1;
		word_counter <= 0;
	     end else begin
		word_counter <= word_counter + 1;
	     end
	  end // case: 2

	  3: begin
	     buf_we <= 0;
	     ctrl_start <= 1;
	     ctrl_addr_offset <= memory_addr_reg;
	     memory_addr_reg <= memory_addr_reg + {target_words[32-1-3:0], 3'b000};
	     ctrl_xfer_size_in_bytes <= {target_words[32-1-3:0], 3'b000}; // words_reg * 8 bytes
	     state_counter <= state_counter + 1;
	  end

	  4: begin
	     ctrl_start <= 0;
	     if(ctrl_start == 0 && ctrl_done == 1) begin
		if(words_reg - target_words == 0) begin
		   state_counter <= 0;
		   words_reg <= 0;
		end else begin
		   words_reg <= words_reg - target_words;
		   addr <= offset_reg + target_words;
		   state_counter <= 1;
		   if(words_reg - target_words > MAX_WORDS_NUM) begin
		      target_words <= MAX_WORDS_NUM;
		   end else begin
		      target_words <= words_reg - target_words;
		   end
		end
	     end
	  end

	  default: begin
	     buf_we <= 0;
	     state_counter <= 0;
	     ctrl_start <= 0;
	  end
	  
	endcase
      
   end
   
   
   fifo_512_512_ft fifo_512_512_ft_i (
				      .clk (clk),
				      .srst(reset),
				      .din      (buf_din),
				      .wr_en    (buf_we),
				      .full     (),
				      .empty    (),
				      .prog_full(buf_full),
				      .rd_en    (m_axis_tready),
				      .dout     (m_axis_tdata),
				      .valid    (m_axis_tvalid),
				      .wr_rst_busy(),
				      .rd_rst_busy()
				      );

endmodule // result_copy


`default_nettype wire
