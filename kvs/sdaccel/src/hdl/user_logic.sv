`default_nettype none

module user_logic
  #(
    parameter integer C_M_AXI_DATA_WIDTH = 512
    )
   (
    input wire 				 aclk,
    input wire 				 areset,
    input wire 				 kernel_clk,
    input wire 				 kernel_rst,
    
    input wire 				 p00_rd_tvalid,
    output wire 			 p00_rd_tready,
    input wire 				 p00_rd_tlast,
    input wire [C_M_AXI_DATA_WIDTH-1:0]  p00_rd_tdata,
    output wire 			 p00_wr_tvalid,
    input wire 				 p00_wr_tready,
    output wire [C_M_AXI_DATA_WIDTH-1:0] p00_wr_tdata
    );

   logic           p00_rd_full;
   logic           p00_rd_prog_full;
   logic           p00_rd_empty;
   logic           p00_user_rd;
   logic [512-1:0] p00_user_din;
   logic           p00_user_valid;

   assign p00_rd_tready = ~p00_rd_prog_full;
   fifo_512_512_ft inst_fifo_p00_rd (
     .clk (aclk),
     .srst(areset),
     .din      (p00_rd_tdata),
     .wr_en    (p00_rd_tvalid && ~p00_rd_prog_full),
     .full     (p00_rd_full),
     .empty    (p00_rd_empty),
     .prog_full(p00_rd_prog_full),
     .rd_en    (p00_user_rd),
     .dout     (p00_user_din),
     .valid    (p00_user_valid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );

   logic           p00_wr_full;
   logic           p00_wr_prog_full;
   logic           p00_wr_empty;
   logic           p00_user_wr;
   logic [512-1:0] p00_user_dout;

   fifo_512_512_ft inst_fifo_p00_wr (
     .clk (aclk),
     .srst(areset),
     .din      (p00_user_dout),
     .wr_en    (p00_user_wr),
     .full     (p00_wr_full),
     .empty    (p00_wr_empty),
     .prog_full(p00_wr_prog_full),
     .rd_en    (p00_wr_tready),
     .dout     (p00_wr_tdata),
     .valid    (p00_wr_tvalid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );

   always @(posedge aclk) begin
      if(p00_wr_prog_full == 1'b0) begin
	 p00_user_rd <= 1'b1;
      end else begin
	 p00_user_rd <= 1'b0;
      end
      if(p00_user_valid == 1'b1) begin
	 p00_user_dout <= p00_user_din + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;
	 p00_user_wr <= 1'b1;
      end else begin
	 p00_user_wr <= 1'b0;
      end
   end

endmodule // user_logic

`default_nettype wire
