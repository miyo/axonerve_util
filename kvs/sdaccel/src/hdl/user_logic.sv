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

   logic           p00_wr_full;
   logic           p00_wr_prog_full;
   logic           p00_wr_empty;
   logic           p00_user_wr;
   logic [512-1:0] p00_user_dout;
   
   logic 		 I_CLK;
   logic 		 I_CLKX2;
   logic 		 I_XRST;
   logic [31:0] 	 O_VERSION;
   logic 		 O_READY;
   logic 		 O_WAIT;

   logic 		 O_ACK;
   logic 		 O_ENT_ERR;
   logic 		 O_SINGLE_HIT;
   logic 		 O_MULTIL_HIT;
   logic [127:0] 	 O_KEY_DAT;
   logic [127:0] 	 O_EKEY_MSK;
   logic [6:0] 		 O_KEY_PRI;
   logic [31:0] 	 O_KEY_VALUE;
   logic 		 O_CMD_EMPTY;
   logic 		 O_CMD_FULL;
   logic 		 O_ENT_FULL;

   logic 		 I_CMD_INIT;
   logic 		 I_CMD_VALID;
   logic 		 I_CMD_ERASE;
   logic 		 I_CMD_WRITE;
   logic 		 I_CMD_READ;
   logic 		 I_CMD_SEARCH;
   logic 		 I_CMD_UPDATE;
   logic [127:0] 	 I_KEY_DAT;
   logic [127:0] 	 I_EKEY_MSK;
   logic [6:0] 		 I_KEY_PRI;
   logic [31:0] 	 I_KEY_VALUE;
   

   assign p00_rd_tready = ~p00_rd_prog_full;
   fifo_512_512_ft inst_fifo_p00_rd (
     .clk (aclk),
     .srst(areset),
     .din      (p00_rd_tdata),
     .wr_en    (p00_rd_tvalid && ~O_CMD_FULL),
     .full     (p00_rd_full),
     .empty    (p00_rd_empty),
     .prog_full(p00_rd_prog_full),
     .rd_en    (p00_user_rd),
     .dout     (p00_user_din),
     .valid    (p00_user_valid),
     .wr_rst_busy(),
     .rd_rst_busy()
   );

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
      if(O_CMD_FULL == 1'b0) begin
	 p00_user_rd <= 1'b1;
      end else begin
	 p00_user_rd <= 1'b0;
      end
      if(p00_user_valid == 1'b1) begin
	 
	 I_CMD_VALID <= 1'b1;
	 
	 I_KEY_DAT[127:0]  <= p00_user_din[127:0];
	 I_KEY_VALUE[31:0] <= p00_user_din[159:128];
	 I_CMD_INIT   <= p00_user_din[160];
	 I_CMD_ERASE  <= p00_user_din[161];
	 I_CMD_WRITE  <= p00_user_din[162];
	 I_CMD_READ   <= p00_user_din[163];
	 I_CMD_SEARCH <= p00_user_din[164];
	 I_CMD_UPDATE <= p00_user_din[165];
	 I_KEY_PRI[6:0] <= p00_user_din[198:192];
	 I_EKEY_MSK[127:0] <= p00_user_din[351:224];
	 
      end else begin
	 I_CMD_VALID <= 1'b0;
      end // else: !if(p00_user_valid == 1'b1)

      if(O_ACK == 1'b1) begin
	 p00_user_wr <= 1'b1;

	 p00_user_dout[127:0] <= O_KEY_DAT[127:0];
	 p00_user_dout[159:128] <= O_KEY_VALUE[31:0];
	 p00_user_dout[160] <= O_SINGLE_HIT;
	 p00_user_dout[161] <= O_MULTIL_HIT;
	 p00_user_dout[162] <= O_ENT_ERR;
	 p00_user_dout[163] <= O_ENT_FULL;
	 p00_user_dout[198:192] <= O_KEY_PRI[6:0];
	 p00_user_dout[351:224] <= O_EKEY_MSK;
	 p00_user_dout[511:480] <= O_VERSION;
	 
      end else begin
	 p00_user_wr <= 1'b0;
      end
      
   end // always @ (posedge aclk)

   assign I_CLK = aclk;
   assign I_CLKX2 = kernel_clk;
   assign I_XRST = ~areset;
   
   axonerve_kvs_kernel
     inst_axonerve_kvs_kernel(
			      .I_CLK(I_CLK),
			      .I_CLKX2(I_CLKX2),
			      .I_XRST(I_XRST), // active low
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


endmodule // user_logic

`default_nettype wire
