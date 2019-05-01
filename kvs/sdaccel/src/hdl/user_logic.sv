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
    output wire [C_M_AXI_DATA_WIDTH-1:0] p00_wr_tdata,

    input wire 				 p01_rd_tvalid,
    output wire 			 p01_rd_tready,
    input wire 				 p01_rd_tlast,
    input wire [C_M_AXI_DATA_WIDTH-1:0]  p01_rd_tdata,
    output wire 			 p01_wr_tvalid,
    input wire 				 p01_wr_tready,
    output wire [C_M_AXI_DATA_WIDTH-1:0] p01_wr_tdata,

    input wire 				 p02_rd_tvalid,
    output wire 			 p02_rd_tready,
    input wire 				 p02_rd_tlast,
    input wire [C_M_AXI_DATA_WIDTH-1:0]  p02_rd_tdata,
    output wire 			 p02_wr_tvalid,
    input wire 				 p02_wr_tready,
    output wire [C_M_AXI_DATA_WIDTH-1:0] p02_wr_tdata,

    input wire 				 p03_rd_tvalid,
    output wire 			 p03_rd_tready,
    input wire 				 p03_rd_tlast,
    input wire [C_M_AXI_DATA_WIDTH-1:0]  p03_rd_tdata,
    output wire 			 p03_wr_tvalid,
    input wire 				 p03_wr_tready,
    output wire [C_M_AXI_DATA_WIDTH-1:0] p03_wr_tdata,

    input wire 				 p04_rd_tvalid,
    output wire 			 p04_rd_tready,
    input wire 				 p04_rd_tlast,
    input wire [C_M_AXI_DATA_WIDTH-1:0]  p04_rd_tdata,
    output wire 			 p04_wr_tvalid,
    input wire 				 p04_wr_tready,
    output wire [C_M_AXI_DATA_WIDTH-1:0] p04_wr_tdata,

    input wire 				 p05_rd_tvalid,
    output wire 			 p05_rd_tready,
    input wire 				 p05_rd_tlast,
    input wire [C_M_AXI_DATA_WIDTH-1:0]  p05_rd_tdata,
    output wire 			 p05_wr_tvalid,
    input wire 				 p05_wr_tready,
    output wire [C_M_AXI_DATA_WIDTH-1:0] p05_wr_tdata
    );

/*
   assign p00_rd_tready = p00_wr_tready;
   assign p00_wr_tvalid = p00_rd_tvalid;
   assign p00_wr_tdata = p00_rd_tdata + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;

   assign p01_rd_tready = p01_wr_tready;
   assign p01_wr_tvalid = p01_rd_tvalid;
   assign p01_wr_tdata = p01_rd_tdata + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;

   assign p02_rd_tready = p02_wr_tready;
   assign p02_wr_tvalid = p02_rd_tvalid;
   assign p02_wr_tdata = p02_rd_tdata + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;

   assign p03_rd_tready = p03_wr_tready;
   assign p03_wr_tvalid = p03_rd_tvalid;
   assign p03_wr_tdata = p03_rd_tdata + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;

   assign p04_rd_tready = p04_wr_tready;
   assign p04_wr_tvalid = p04_rd_tvalid;
   assign p04_wr_tdata = p04_rd_tdata + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;

   assign p05_rd_tready = p05_wr_tready;
   assign p05_wr_tvalid = p05_rd_tvalid;
   assign p05_wr_tdata = p05_rd_tdata + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;
*/

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

   logic           p01_rd_full;
   logic           p01_rd_prog_full;
   logic           p01_rd_empty;
   logic           p01_user_rd;
   logic [512-1:0] p01_user_din;
   logic           p01_user_valid;

   assign p01_rd_tready = ~p01_rd_prog_full;
   fifo_512_512_ft inst_fifo_p01_rd (
     .clk (aclk),
     .srst(areset),
     .din      (p01_rd_tdata),
     .wr_en    (p01_rd_tvalid && ~p01_rd_prog_full),
     .full     (p01_rd_full),
     .empty    (p01_rd_empty),
     .prog_full(p01_rd_prog_full),
     .rd_en    (p01_user_rd),
     .dout     (p01_user_din),
     .valid    (p01_user_valid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );

   logic           p01_wr_full;
   logic           p01_wr_prog_full;
   logic           p01_wr_empty;
   logic           p01_user_wr;
   logic [512-1:0] p01_user_dout;

   fifo_512_512_ft inst_fifo_p01_wr (
     .clk (aclk),
     .srst(areset),
     .din      (p01_user_dout),
     .wr_en    (p01_user_wr),
     .full     (p01_wr_full),
     .empty    (p01_wr_empty),
     .prog_full(p01_wr_prog_full),
     .rd_en    (p01_wr_tready),
     .dout     (p01_wr_tdata),
     .valid    (p01_wr_tvalid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );

   logic           p02_rd_full;
   logic           p02_rd_prog_full;
   logic           p02_rd_empty;
   logic           p02_user_rd;
   logic [512-1:0] p02_user_din;
   logic           p02_user_valid;

   assign p02_rd_tready = ~p02_rd_prog_full;
   fifo_512_512_ft inst_fifo_p02_rd (
     .clk (aclk),
     .srst(areset),
     .din      (p02_rd_tdata),
     .wr_en    (p02_rd_tvalid && ~p02_rd_prog_full),
     .full     (p02_rd_full),
     .empty    (p02_rd_empty),
     .prog_full(p02_rd_prog_full),
     .rd_en    (p02_user_rd),
     .dout     (p02_user_din),
     .valid    (p02_user_valid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );

   logic           p02_wr_full;
   logic           p02_wr_prog_full;
   logic           p02_wr_empty;
   logic           p02_user_wr;
   logic [512-1:0] p02_user_dout;

   fifo_512_512_ft inst_fifo_p02_wr (
     .clk (aclk),
     .srst(areset),
     .din      (p02_user_dout),
     .wr_en    (p02_user_wr),
     .full     (p02_wr_full),
     .empty    (p02_wr_empty),
     .prog_full(p02_wr_prog_full),
     .rd_en    (p02_wr_tready),
     .dout     (p02_wr_tdata),
     .valid    (p02_wr_tvalid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );
   
   logic           p03_rd_full;
   logic           p03_rd_prog_full;
   logic           p03_rd_empty;
   logic           p03_user_rd;
   logic [512-1:0] p03_user_din;
   logic           p03_user_valid;

   assign p03_rd_tready = ~p03_rd_prog_full;
   fifo_512_512_ft inst_fifo_p03_rd (
     .clk (aclk),
     .srst(areset),
     .din      (p03_rd_tdata),
     .wr_en    (p03_rd_tvalid && ~p03_rd_prog_full),
     .full     (p03_rd_full),
     .empty    (p03_rd_empty),
     .prog_full(p03_rd_prog_full),
     .rd_en    (p03_user_rd),
     .dout     (p03_user_din),
     .valid    (p03_user_valid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );

   logic           p03_wr_full;
   logic           p03_wr_prog_full;
   logic           p03_wr_empty;
   logic           p03_user_wr;
   logic [512-1:0] p03_user_dout;

   fifo_512_512_ft inst_fifo_p03_wr (
     .clk (aclk),
     .srst(areset),
     .din      (p03_user_dout),
     .wr_en    (p03_user_wr),
     .full     (p03_wr_full),
     .empty    (p03_wr_empty),
     .prog_full(p03_wr_prog_full),
     .rd_en    (p03_wr_tready),
     .dout     (p03_wr_tdata),
     .valid    (p03_wr_tvalid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );

   logic           p04_rd_full;
   logic           p04_rd_prog_full;
   logic           p04_rd_empty;
   logic           p04_user_rd;
   logic [512-1:0] p04_user_din;
   logic           p04_user_valid;

   assign p04_rd_tready = ~p04_rd_prog_full;
   fifo_512_512_ft inst_fifo_p04_rd (
     .clk (aclk),
     .srst(areset),
     .din      (p04_rd_tdata),
     .wr_en    (p04_rd_tvalid && ~p04_rd_prog_full),
     .full     (p04_rd_full),
     .empty    (p04_rd_empty),
     .prog_full(p04_rd_prog_full),
     .rd_en    (p04_user_rd),
     .dout     (p04_user_din),
     .valid    (p04_user_valid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );

   logic           p04_wr_full;
   logic           p04_wr_prog_full;
   logic           p04_wr_empty;
   logic           p04_user_wr;
   logic [512-1:0] p04_user_dout;

   fifo_512_512_ft inst_fifo_p04_wr (
     .clk (aclk),
     .srst(areset),
     .din      (p04_user_dout),
     .wr_en    (p04_user_wr),
     .full     (p04_wr_full),
     .empty    (p04_wr_empty),
     .prog_full(p04_wr_prog_full),
     .rd_en    (p04_wr_tready),
     .dout     (p04_wr_tdata),
     .valid    (p04_wr_tvalid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );

   logic           p05_rd_full;
   logic           p05_rd_prog_full;
   logic           p05_rd_empty;
   logic           p05_user_rd;
   logic [512-1:0] p05_user_din;
   logic           p05_user_valid;

   assign p05_rd_tready = ~p05_rd_prog_full;
   fifo_512_512_ft inst_fifo_p05_rd (
     .clk (aclk),
     .srst(areset),
     .din      (p05_rd_tdata),
     .wr_en    (p05_rd_tvalid && ~p05_rd_prog_full),
     .full     (p05_rd_full),
     .empty    (p05_rd_empty),
     .prog_full(p05_rd_prog_full),
     .rd_en    (p05_user_rd),
     .dout     (p05_user_din),
     .valid    (p05_user_valid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );

   logic           p05_wr_full;
   logic           p05_wr_prog_full;
   logic           p05_wr_empty;
   logic           p05_user_wr;
   logic [512-1:0] p05_user_dout;

   fifo_512_512_ft inst_fifo_p05_wr (
     .clk (aclk),
     .srst(areset),
     .din      (p05_user_dout),
     .wr_en    (p05_user_wr),
     .full     (p05_wr_full),
     .empty    (p05_wr_empty),
     .prog_full(p05_wr_prog_full),
     .rd_en    (p05_wr_tready),
     .dout     (p05_wr_tdata),
     .valid    (p05_wr_tvalid),
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

   always @(posedge aclk) begin
      if(p01_wr_prog_full == 1'b0) begin
	 p01_user_rd <= 1'b1;
      end else begin
	 p01_user_rd <= 1'b0;
      end
      if(p01_user_valid == 1'b1) begin
	 p01_user_dout <= p01_user_din + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;
	 p01_user_wr <= 1'b1;
      end else begin
	 p01_user_wr <= 1'b0;
      end
   end

   always @(posedge aclk) begin
      if(p02_wr_prog_full == 1'b0) begin
	 p02_user_rd <= 1'b1;
      end else begin
	 p02_user_rd <= 1'b0;
      end
      if(p02_user_valid == 1'b1) begin
	 p02_user_dout <= p02_user_din + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;
	 p02_user_wr <= 1'b1;
      end else begin
	 p02_user_wr <= 1'b0;
      end
   end

   always @(posedge aclk) begin
      if(p03_wr_prog_full == 1'b0) begin
	 p03_user_rd <= 1'b1;
      end else begin
	 p03_user_rd <= 1'b0;
      end
      if(p03_user_valid == 1'b1) begin
	 p03_user_dout <= p03_user_din + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;
	 p03_user_wr <= 1'b1;
      end else begin
	 p03_user_wr <= 1'b0;
      end
   end

   always @(posedge aclk) begin
      if(p04_wr_prog_full == 1'b0) begin
	 p04_user_rd <= 1'b1;
      end else begin
	 p04_user_rd <= 1'b0;
      end
      if(p04_user_valid == 1'b1) begin
	 p04_user_dout <= p04_user_din + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;
	 p04_user_wr <= 1'b1;
      end else begin
	 p04_user_wr <= 1'b0;
      end
   end

   always @(posedge aclk) begin
      if(p05_wr_prog_full == 1'b0) begin
	 p05_user_rd <= 1'b1;
      end else begin
	 p05_user_rd <= 1'b0;
      end
      if(p05_user_valid == 1'b1) begin
	 p05_user_dout <= p05_user_din + 512'h00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001;
	 p05_user_wr <= 1'b1;
      end else begin
	 p05_user_wr <= 1'b0;
      end
   end

endmodule // user_logic

`default_nettype wire
