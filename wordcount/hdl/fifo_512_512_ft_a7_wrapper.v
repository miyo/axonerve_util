`default_nettype none

module fifo_512_512_ft (
			input wire 	    clk,
			input wire 	    srst,
			input wire [511:0]  din,
			input wire 	    wr_en,
			output wire 	    full,
			output wire 	    empty,
			output wire 	    prog_full,
			input wire 	    rd_en,
			output wire [511:0] dout,
			output wire 	    valid,
			output wire 	    wr_rst_busy,
			output wire 	    rd_rst_busy
			);
   
   assign wr_rst_busy = 0;
   assign rd_rst_busy = 0;

   fifo_512_512_ft_a7 u(
			.clk (clk),
			.srst(srst),
			.din      (din),
			.wr_en    (wr_en),
			.full     (full),
			.empty    (empty),
			.prog_full(prog_full),
			.rd_en    (rd_en),
			.dout     (dout),
			.valid    (valid)
			);

endmodule // fifo_512_512_ft

`default_nettype wire
