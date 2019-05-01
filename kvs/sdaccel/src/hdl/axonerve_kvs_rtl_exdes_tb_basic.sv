// This is a generated file. Use and modify at your own risk.
////////////////////////////////////////////////////////////////////////////////
// default_nettype of none prevents implicit wire declaration.
`default_nettype none
`timescale 1 ps / 1 ps
import axi_vip_pkg::*;
import slv_m00_axi_vip_pkg::*;
import slv_m01_axi_vip_pkg::*;
import slv_m02_axi_vip_pkg::*;
import slv_m03_axi_vip_pkg::*;
import slv_m04_axi_vip_pkg::*;
import slv_m05_axi_vip_pkg::*;
import control_axonerve_kvs_rtl_vip_pkg::*;

module axonerve_kvs_rtl_exdes_tb_basic ();
parameter integer LP_MAX_LENGTH = 8192;
parameter integer LP_MAX_TRANSFER_LENGTH = 16384 / 4;
parameter KRNL_CTRL_REG_ADDR = 32'h00000000;
parameter KRNL_GIE_REG_ADDR  = 32'h00000004;
parameter KRNL_IER_REG_ADDR  = 32'h00000008;
parameter KRNL_ISR_REG_ADDR  = 32'h0000000c;
parameter CONTROL_START_MASK = 32'h00000001;
parameter CONTROL_DONE_MASK  = 32'h00000002;
parameter CONTROL_IDLE_MASK  = 32'h00000004;
parameter integer C_S_AXI_CONTROL_ADDR_WIDTH = 12;
parameter integer C_S_AXI_CONTROL_DATA_WIDTH = 32;
parameter integer C_M00_AXI_ADDR_WIDTH = 64;
parameter integer C_M00_AXI_DATA_WIDTH = 512;
parameter integer C_M01_AXI_ADDR_WIDTH = 64;
parameter integer C_M01_AXI_DATA_WIDTH = 512;
parameter integer C_M02_AXI_ADDR_WIDTH = 64;
parameter integer C_M02_AXI_DATA_WIDTH = 512;
parameter integer C_M03_AXI_ADDR_WIDTH = 64;
parameter integer C_M03_AXI_DATA_WIDTH = 512;
parameter integer C_M04_AXI_ADDR_WIDTH = 64;
parameter integer C_M04_AXI_DATA_WIDTH = 512;
parameter integer C_M05_AXI_ADDR_WIDTH = 64;
parameter integer C_M05_AXI_DATA_WIDTH = 512;

parameter integer LP_CLK_PERIOD_PS = 4000; // 250 MHz

//System Signals
logic ap_clk = 0;

initial begin: AP_CLK
  forever begin
    ap_clk = #(LP_CLK_PERIOD_PS/2) ~ap_clk;
  end
end

parameter integer LP_CLK2_PERIOD_PS = 5000; // 200 MHz

logic ap_clk_2 = 0;

initial begin: AP_CLK_2
  forever begin
    ap_clk_2 = #(LP_CLK2_PERIOD_PS/2) ~ap_clk_2;
  end
end
//AXI4 master interface m00_axi
wire [1-1:0] m00_axi_awvalid;
wire [1-1:0] m00_axi_awready;
wire [C_M00_AXI_ADDR_WIDTH-1:0] m00_axi_awaddr;
wire [8-1:0] m00_axi_awlen;
wire [1-1:0] m00_axi_wvalid;
wire [1-1:0] m00_axi_wready;
wire [C_M00_AXI_DATA_WIDTH-1:0] m00_axi_wdata;
wire [C_M00_AXI_DATA_WIDTH/8-1:0] m00_axi_wstrb;
wire [1-1:0] m00_axi_wlast;
wire [1-1:0] m00_axi_bvalid;
wire [1-1:0] m00_axi_bready;
wire [1-1:0] m00_axi_arvalid;
wire [1-1:0] m00_axi_arready;
wire [C_M00_AXI_ADDR_WIDTH-1:0] m00_axi_araddr;
wire [8-1:0] m00_axi_arlen;
wire [1-1:0] m00_axi_rvalid;
wire [1-1:0] m00_axi_rready;
wire [C_M00_AXI_DATA_WIDTH-1:0] m00_axi_rdata;
wire [1-1:0] m00_axi_rlast;
//AXI4 master interface m01_axi
wire [1-1:0] m01_axi_awvalid;
wire [1-1:0] m01_axi_awready;
wire [C_M01_AXI_ADDR_WIDTH-1:0] m01_axi_awaddr;
wire [8-1:0] m01_axi_awlen;
wire [1-1:0] m01_axi_wvalid;
wire [1-1:0] m01_axi_wready;
wire [C_M01_AXI_DATA_WIDTH-1:0] m01_axi_wdata;
wire [C_M01_AXI_DATA_WIDTH/8-1:0] m01_axi_wstrb;
wire [1-1:0] m01_axi_wlast;
wire [1-1:0] m01_axi_bvalid;
wire [1-1:0] m01_axi_bready;
wire [1-1:0] m01_axi_arvalid;
wire [1-1:0] m01_axi_arready;
wire [C_M01_AXI_ADDR_WIDTH-1:0] m01_axi_araddr;
wire [8-1:0] m01_axi_arlen;
wire [1-1:0] m01_axi_rvalid;
wire [1-1:0] m01_axi_rready;
wire [C_M01_AXI_DATA_WIDTH-1:0] m01_axi_rdata;
wire [1-1:0] m01_axi_rlast;
//AXI4 master interface m02_axi
wire [1-1:0] m02_axi_awvalid;
wire [1-1:0] m02_axi_awready;
wire [C_M02_AXI_ADDR_WIDTH-1:0] m02_axi_awaddr;
wire [8-1:0] m02_axi_awlen;
wire [1-1:0] m02_axi_wvalid;
wire [1-1:0] m02_axi_wready;
wire [C_M02_AXI_DATA_WIDTH-1:0] m02_axi_wdata;
wire [C_M02_AXI_DATA_WIDTH/8-1:0] m02_axi_wstrb;
wire [1-1:0] m02_axi_wlast;
wire [1-1:0] m02_axi_bvalid;
wire [1-1:0] m02_axi_bready;
wire [1-1:0] m02_axi_arvalid;
wire [1-1:0] m02_axi_arready;
wire [C_M02_AXI_ADDR_WIDTH-1:0] m02_axi_araddr;
wire [8-1:0] m02_axi_arlen;
wire [1-1:0] m02_axi_rvalid;
wire [1-1:0] m02_axi_rready;
wire [C_M02_AXI_DATA_WIDTH-1:0] m02_axi_rdata;
wire [1-1:0] m02_axi_rlast;
//AXI4 master interface m03_axi
wire [1-1:0] m03_axi_awvalid;
wire [1-1:0] m03_axi_awready;
wire [C_M03_AXI_ADDR_WIDTH-1:0] m03_axi_awaddr;
wire [8-1:0] m03_axi_awlen;
wire [1-1:0] m03_axi_wvalid;
wire [1-1:0] m03_axi_wready;
wire [C_M03_AXI_DATA_WIDTH-1:0] m03_axi_wdata;
wire [C_M03_AXI_DATA_WIDTH/8-1:0] m03_axi_wstrb;
wire [1-1:0] m03_axi_wlast;
wire [1-1:0] m03_axi_bvalid;
wire [1-1:0] m03_axi_bready;
wire [1-1:0] m03_axi_arvalid;
wire [1-1:0] m03_axi_arready;
wire [C_M03_AXI_ADDR_WIDTH-1:0] m03_axi_araddr;
wire [8-1:0] m03_axi_arlen;
wire [1-1:0] m03_axi_rvalid;
wire [1-1:0] m03_axi_rready;
wire [C_M03_AXI_DATA_WIDTH-1:0] m03_axi_rdata;
wire [1-1:0] m03_axi_rlast;
//AXI4 master interface m04_axi
wire [1-1:0] m04_axi_awvalid;
wire [1-1:0] m04_axi_awready;
wire [C_M04_AXI_ADDR_WIDTH-1:0] m04_axi_awaddr;
wire [8-1:0] m04_axi_awlen;
wire [1-1:0] m04_axi_wvalid;
wire [1-1:0] m04_axi_wready;
wire [C_M04_AXI_DATA_WIDTH-1:0] m04_axi_wdata;
wire [C_M04_AXI_DATA_WIDTH/8-1:0] m04_axi_wstrb;
wire [1-1:0] m04_axi_wlast;
wire [1-1:0] m04_axi_bvalid;
wire [1-1:0] m04_axi_bready;
wire [1-1:0] m04_axi_arvalid;
wire [1-1:0] m04_axi_arready;
wire [C_M04_AXI_ADDR_WIDTH-1:0] m04_axi_araddr;
wire [8-1:0] m04_axi_arlen;
wire [1-1:0] m04_axi_rvalid;
wire [1-1:0] m04_axi_rready;
wire [C_M04_AXI_DATA_WIDTH-1:0] m04_axi_rdata;
wire [1-1:0] m04_axi_rlast;
//AXI4 master interface m05_axi
wire [1-1:0] m05_axi_awvalid;
wire [1-1:0] m05_axi_awready;
wire [C_M05_AXI_ADDR_WIDTH-1:0] m05_axi_awaddr;
wire [8-1:0] m05_axi_awlen;
wire [1-1:0] m05_axi_wvalid;
wire [1-1:0] m05_axi_wready;
wire [C_M05_AXI_DATA_WIDTH-1:0] m05_axi_wdata;
wire [C_M05_AXI_DATA_WIDTH/8-1:0] m05_axi_wstrb;
wire [1-1:0] m05_axi_wlast;
wire [1-1:0] m05_axi_bvalid;
wire [1-1:0] m05_axi_bready;
wire [1-1:0] m05_axi_arvalid;
wire [1-1:0] m05_axi_arready;
wire [C_M05_AXI_ADDR_WIDTH-1:0] m05_axi_araddr;
wire [8-1:0] m05_axi_arlen;
wire [1-1:0] m05_axi_rvalid;
wire [1-1:0] m05_axi_rready;
wire [C_M05_AXI_DATA_WIDTH-1:0] m05_axi_rdata;
wire [1-1:0] m05_axi_rlast;
//AXI4LITE control signals
wire [1-1:0] s_axi_control_awvalid;
wire [1-1:0] s_axi_control_awready;
wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0] s_axi_control_awaddr;
wire [1-1:0] s_axi_control_wvalid;
wire [1-1:0] s_axi_control_wready;
wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0] s_axi_control_wdata;
wire [C_S_AXI_CONTROL_DATA_WIDTH/8-1:0] s_axi_control_wstrb;
wire [1-1:0] s_axi_control_arvalid;
wire [1-1:0] s_axi_control_arready;
wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0] s_axi_control_araddr;
wire [1-1:0] s_axi_control_rvalid;
wire [1-1:0] s_axi_control_rready;
wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0] s_axi_control_rdata;
wire [2-1:0] s_axi_control_rresp;
wire [1-1:0] s_axi_control_bvalid;
wire [1-1:0] s_axi_control_bready;
wire [2-1:0] s_axi_control_bresp;
wire interrupt;

// DUT instantiation
axonerve_kvs_rtl #(
  .C_S_AXI_CONTROL_ADDR_WIDTH ( C_S_AXI_CONTROL_ADDR_WIDTH ),
  .C_S_AXI_CONTROL_DATA_WIDTH ( C_S_AXI_CONTROL_DATA_WIDTH ),
  .C_M00_AXI_ADDR_WIDTH       ( C_M00_AXI_ADDR_WIDTH       ),
  .C_M00_AXI_DATA_WIDTH       ( C_M00_AXI_DATA_WIDTH       ),
  .C_M01_AXI_ADDR_WIDTH       ( C_M01_AXI_ADDR_WIDTH       ),
  .C_M01_AXI_DATA_WIDTH       ( C_M01_AXI_DATA_WIDTH       ),
  .C_M02_AXI_ADDR_WIDTH       ( C_M02_AXI_ADDR_WIDTH       ),
  .C_M02_AXI_DATA_WIDTH       ( C_M02_AXI_DATA_WIDTH       ),
  .C_M03_AXI_ADDR_WIDTH       ( C_M03_AXI_ADDR_WIDTH       ),
  .C_M03_AXI_DATA_WIDTH       ( C_M03_AXI_DATA_WIDTH       ),
  .C_M04_AXI_ADDR_WIDTH       ( C_M04_AXI_ADDR_WIDTH       ),
  .C_M04_AXI_DATA_WIDTH       ( C_M04_AXI_DATA_WIDTH       ),
  .C_M05_AXI_ADDR_WIDTH       ( C_M05_AXI_ADDR_WIDTH       ),
  .C_M05_AXI_DATA_WIDTH       ( C_M05_AXI_DATA_WIDTH       )
)
inst_dut (
  .ap_clk                ( ap_clk                ),
  .ap_clk_2              ( ap_clk_2              ),
  .m00_axi_awvalid       ( m00_axi_awvalid       ),
  .m00_axi_awready       ( m00_axi_awready       ),
  .m00_axi_awaddr        ( m00_axi_awaddr        ),
  .m00_axi_awlen         ( m00_axi_awlen         ),
  .m00_axi_wvalid        ( m00_axi_wvalid        ),
  .m00_axi_wready        ( m00_axi_wready        ),
  .m00_axi_wdata         ( m00_axi_wdata         ),
  .m00_axi_wstrb         ( m00_axi_wstrb         ),
  .m00_axi_wlast         ( m00_axi_wlast         ),
  .m00_axi_bvalid        ( m00_axi_bvalid        ),
  .m00_axi_bready        ( m00_axi_bready        ),
  .m00_axi_arvalid       ( m00_axi_arvalid       ),
  .m00_axi_arready       ( m00_axi_arready       ),
  .m00_axi_araddr        ( m00_axi_araddr        ),
  .m00_axi_arlen         ( m00_axi_arlen         ),
  .m00_axi_rvalid        ( m00_axi_rvalid        ),
  .m00_axi_rready        ( m00_axi_rready        ),
  .m00_axi_rdata         ( m00_axi_rdata         ),
  .m00_axi_rlast         ( m00_axi_rlast         ),
  .m01_axi_awvalid       ( m01_axi_awvalid       ),
  .m01_axi_awready       ( m01_axi_awready       ),
  .m01_axi_awaddr        ( m01_axi_awaddr        ),
  .m01_axi_awlen         ( m01_axi_awlen         ),
  .m01_axi_wvalid        ( m01_axi_wvalid        ),
  .m01_axi_wready        ( m01_axi_wready        ),
  .m01_axi_wdata         ( m01_axi_wdata         ),
  .m01_axi_wstrb         ( m01_axi_wstrb         ),
  .m01_axi_wlast         ( m01_axi_wlast         ),
  .m01_axi_bvalid        ( m01_axi_bvalid        ),
  .m01_axi_bready        ( m01_axi_bready        ),
  .m01_axi_arvalid       ( m01_axi_arvalid       ),
  .m01_axi_arready       ( m01_axi_arready       ),
  .m01_axi_araddr        ( m01_axi_araddr        ),
  .m01_axi_arlen         ( m01_axi_arlen         ),
  .m01_axi_rvalid        ( m01_axi_rvalid        ),
  .m01_axi_rready        ( m01_axi_rready        ),
  .m01_axi_rdata         ( m01_axi_rdata         ),
  .m01_axi_rlast         ( m01_axi_rlast         ),
  .m02_axi_awvalid       ( m02_axi_awvalid       ),
  .m02_axi_awready       ( m02_axi_awready       ),
  .m02_axi_awaddr        ( m02_axi_awaddr        ),
  .m02_axi_awlen         ( m02_axi_awlen         ),
  .m02_axi_wvalid        ( m02_axi_wvalid        ),
  .m02_axi_wready        ( m02_axi_wready        ),
  .m02_axi_wdata         ( m02_axi_wdata         ),
  .m02_axi_wstrb         ( m02_axi_wstrb         ),
  .m02_axi_wlast         ( m02_axi_wlast         ),
  .m02_axi_bvalid        ( m02_axi_bvalid        ),
  .m02_axi_bready        ( m02_axi_bready        ),
  .m02_axi_arvalid       ( m02_axi_arvalid       ),
  .m02_axi_arready       ( m02_axi_arready       ),
  .m02_axi_araddr        ( m02_axi_araddr        ),
  .m02_axi_arlen         ( m02_axi_arlen         ),
  .m02_axi_rvalid        ( m02_axi_rvalid        ),
  .m02_axi_rready        ( m02_axi_rready        ),
  .m02_axi_rdata         ( m02_axi_rdata         ),
  .m02_axi_rlast         ( m02_axi_rlast         ),
  .m03_axi_awvalid       ( m03_axi_awvalid       ),
  .m03_axi_awready       ( m03_axi_awready       ),
  .m03_axi_awaddr        ( m03_axi_awaddr        ),
  .m03_axi_awlen         ( m03_axi_awlen         ),
  .m03_axi_wvalid        ( m03_axi_wvalid        ),
  .m03_axi_wready        ( m03_axi_wready        ),
  .m03_axi_wdata         ( m03_axi_wdata         ),
  .m03_axi_wstrb         ( m03_axi_wstrb         ),
  .m03_axi_wlast         ( m03_axi_wlast         ),
  .m03_axi_bvalid        ( m03_axi_bvalid        ),
  .m03_axi_bready        ( m03_axi_bready        ),
  .m03_axi_arvalid       ( m03_axi_arvalid       ),
  .m03_axi_arready       ( m03_axi_arready       ),
  .m03_axi_araddr        ( m03_axi_araddr        ),
  .m03_axi_arlen         ( m03_axi_arlen         ),
  .m03_axi_rvalid        ( m03_axi_rvalid        ),
  .m03_axi_rready        ( m03_axi_rready        ),
  .m03_axi_rdata         ( m03_axi_rdata         ),
  .m03_axi_rlast         ( m03_axi_rlast         ),
  .m04_axi_awvalid       ( m04_axi_awvalid       ),
  .m04_axi_awready       ( m04_axi_awready       ),
  .m04_axi_awaddr        ( m04_axi_awaddr        ),
  .m04_axi_awlen         ( m04_axi_awlen         ),
  .m04_axi_wvalid        ( m04_axi_wvalid        ),
  .m04_axi_wready        ( m04_axi_wready        ),
  .m04_axi_wdata         ( m04_axi_wdata         ),
  .m04_axi_wstrb         ( m04_axi_wstrb         ),
  .m04_axi_wlast         ( m04_axi_wlast         ),
  .m04_axi_bvalid        ( m04_axi_bvalid        ),
  .m04_axi_bready        ( m04_axi_bready        ),
  .m04_axi_arvalid       ( m04_axi_arvalid       ),
  .m04_axi_arready       ( m04_axi_arready       ),
  .m04_axi_araddr        ( m04_axi_araddr        ),
  .m04_axi_arlen         ( m04_axi_arlen         ),
  .m04_axi_rvalid        ( m04_axi_rvalid        ),
  .m04_axi_rready        ( m04_axi_rready        ),
  .m04_axi_rdata         ( m04_axi_rdata         ),
  .m04_axi_rlast         ( m04_axi_rlast         ),
  .m05_axi_awvalid       ( m05_axi_awvalid       ),
  .m05_axi_awready       ( m05_axi_awready       ),
  .m05_axi_awaddr        ( m05_axi_awaddr        ),
  .m05_axi_awlen         ( m05_axi_awlen         ),
  .m05_axi_wvalid        ( m05_axi_wvalid        ),
  .m05_axi_wready        ( m05_axi_wready        ),
  .m05_axi_wdata         ( m05_axi_wdata         ),
  .m05_axi_wstrb         ( m05_axi_wstrb         ),
  .m05_axi_wlast         ( m05_axi_wlast         ),
  .m05_axi_bvalid        ( m05_axi_bvalid        ),
  .m05_axi_bready        ( m05_axi_bready        ),
  .m05_axi_arvalid       ( m05_axi_arvalid       ),
  .m05_axi_arready       ( m05_axi_arready       ),
  .m05_axi_araddr        ( m05_axi_araddr        ),
  .m05_axi_arlen         ( m05_axi_arlen         ),
  .m05_axi_rvalid        ( m05_axi_rvalid        ),
  .m05_axi_rready        ( m05_axi_rready        ),
  .m05_axi_rdata         ( m05_axi_rdata         ),
  .m05_axi_rlast         ( m05_axi_rlast         ),
  .s_axi_control_awvalid ( s_axi_control_awvalid ),
  .s_axi_control_awready ( s_axi_control_awready ),
  .s_axi_control_awaddr  ( s_axi_control_awaddr  ),
  .s_axi_control_wvalid  ( s_axi_control_wvalid  ),
  .s_axi_control_wready  ( s_axi_control_wready  ),
  .s_axi_control_wdata   ( s_axi_control_wdata   ),
  .s_axi_control_wstrb   ( s_axi_control_wstrb   ),
  .s_axi_control_arvalid ( s_axi_control_arvalid ),
  .s_axi_control_arready ( s_axi_control_arready ),
  .s_axi_control_araddr  ( s_axi_control_araddr  ),
  .s_axi_control_rvalid  ( s_axi_control_rvalid  ),
  .s_axi_control_rready  ( s_axi_control_rready  ),
  .s_axi_control_rdata   ( s_axi_control_rdata   ),
  .s_axi_control_rresp   ( s_axi_control_rresp   ),
  .s_axi_control_bvalid  ( s_axi_control_bvalid  ),
  .s_axi_control_bready  ( s_axi_control_bready  ),
  .s_axi_control_bresp   ( s_axi_control_bresp   ),
  .interrupt             ( interrupt             )
);

// Master Control instantiation
control_axonerve_kvs_rtl_vip inst_control_axonerve_kvs_rtl_vip (
  .aclk          ( ap_clk                ),
  .m_axi_awvalid ( s_axi_control_awvalid ),
  .m_axi_awready ( s_axi_control_awready ),
  .m_axi_awaddr  ( s_axi_control_awaddr  ),
  .m_axi_wvalid  ( s_axi_control_wvalid  ),
  .m_axi_wready  ( s_axi_control_wready  ),
  .m_axi_wdata   ( s_axi_control_wdata   ),
  .m_axi_wstrb   ( s_axi_control_wstrb   ),
  .m_axi_arvalid ( s_axi_control_arvalid ),
  .m_axi_arready ( s_axi_control_arready ),
  .m_axi_araddr  ( s_axi_control_araddr  ),
  .m_axi_rvalid  ( s_axi_control_rvalid  ),
  .m_axi_rready  ( s_axi_control_rready  ),
  .m_axi_rdata   ( s_axi_control_rdata   ),
  .m_axi_rresp   ( s_axi_control_rresp   ),
  .m_axi_bvalid  ( s_axi_control_bvalid  ),
  .m_axi_bready  ( s_axi_control_bready  ),
  .m_axi_bresp   ( s_axi_control_bresp   )
);

control_axonerve_kvs_rtl_vip_mst_t  ctrl;

// Slave MM VIP instantiation
slv_m00_axi_vip inst_slv_m00_axi_vip (
  .aclk          ( ap_clk          ),
  .s_axi_awvalid ( m00_axi_awvalid ),
  .s_axi_awready ( m00_axi_awready ),
  .s_axi_awaddr  ( m00_axi_awaddr  ),
  .s_axi_awlen   ( m00_axi_awlen   ),
  .s_axi_wvalid  ( m00_axi_wvalid  ),
  .s_axi_wready  ( m00_axi_wready  ),
  .s_axi_wdata   ( m00_axi_wdata   ),
  .s_axi_wstrb   ( m00_axi_wstrb   ),
  .s_axi_wlast   ( m00_axi_wlast   ),
  .s_axi_bvalid  ( m00_axi_bvalid  ),
  .s_axi_bready  ( m00_axi_bready  ),
  .s_axi_arvalid ( m00_axi_arvalid ),
  .s_axi_arready ( m00_axi_arready ),
  .s_axi_araddr  ( m00_axi_araddr  ),
  .s_axi_arlen   ( m00_axi_arlen   ),
  .s_axi_rvalid  ( m00_axi_rvalid  ),
  .s_axi_rready  ( m00_axi_rready  ),
  .s_axi_rdata   ( m00_axi_rdata   ),
  .s_axi_rlast   ( m00_axi_rlast   )
);


slv_m00_axi_vip_slv_mem_t   m00_axi;
slv_m00_axi_vip_slv_t   m00_axi_slv;

// Slave MM VIP instantiation
slv_m01_axi_vip inst_slv_m01_axi_vip (
  .aclk          ( ap_clk          ),
  .s_axi_awvalid ( m01_axi_awvalid ),
  .s_axi_awready ( m01_axi_awready ),
  .s_axi_awaddr  ( m01_axi_awaddr  ),
  .s_axi_awlen   ( m01_axi_awlen   ),
  .s_axi_wvalid  ( m01_axi_wvalid  ),
  .s_axi_wready  ( m01_axi_wready  ),
  .s_axi_wdata   ( m01_axi_wdata   ),
  .s_axi_wstrb   ( m01_axi_wstrb   ),
  .s_axi_wlast   ( m01_axi_wlast   ),
  .s_axi_bvalid  ( m01_axi_bvalid  ),
  .s_axi_bready  ( m01_axi_bready  ),
  .s_axi_arvalid ( m01_axi_arvalid ),
  .s_axi_arready ( m01_axi_arready ),
  .s_axi_araddr  ( m01_axi_araddr  ),
  .s_axi_arlen   ( m01_axi_arlen   ),
  .s_axi_rvalid  ( m01_axi_rvalid  ),
  .s_axi_rready  ( m01_axi_rready  ),
  .s_axi_rdata   ( m01_axi_rdata   ),
  .s_axi_rlast   ( m01_axi_rlast   )
);


slv_m01_axi_vip_slv_mem_t   m01_axi;
slv_m01_axi_vip_slv_t   m01_axi_slv;

// Slave MM VIP instantiation
slv_m02_axi_vip inst_slv_m02_axi_vip (
  .aclk          ( ap_clk          ),
  .s_axi_awvalid ( m02_axi_awvalid ),
  .s_axi_awready ( m02_axi_awready ),
  .s_axi_awaddr  ( m02_axi_awaddr  ),
  .s_axi_awlen   ( m02_axi_awlen   ),
  .s_axi_wvalid  ( m02_axi_wvalid  ),
  .s_axi_wready  ( m02_axi_wready  ),
  .s_axi_wdata   ( m02_axi_wdata   ),
  .s_axi_wstrb   ( m02_axi_wstrb   ),
  .s_axi_wlast   ( m02_axi_wlast   ),
  .s_axi_bvalid  ( m02_axi_bvalid  ),
  .s_axi_bready  ( m02_axi_bready  ),
  .s_axi_arvalid ( m02_axi_arvalid ),
  .s_axi_arready ( m02_axi_arready ),
  .s_axi_araddr  ( m02_axi_araddr  ),
  .s_axi_arlen   ( m02_axi_arlen   ),
  .s_axi_rvalid  ( m02_axi_rvalid  ),
  .s_axi_rready  ( m02_axi_rready  ),
  .s_axi_rdata   ( m02_axi_rdata   ),
  .s_axi_rlast   ( m02_axi_rlast   )
);


slv_m02_axi_vip_slv_mem_t   m02_axi;
slv_m02_axi_vip_slv_t   m02_axi_slv;

// Slave MM VIP instantiation
slv_m03_axi_vip inst_slv_m03_axi_vip (
  .aclk          ( ap_clk          ),
  .s_axi_awvalid ( m03_axi_awvalid ),
  .s_axi_awready ( m03_axi_awready ),
  .s_axi_awaddr  ( m03_axi_awaddr  ),
  .s_axi_awlen   ( m03_axi_awlen   ),
  .s_axi_wvalid  ( m03_axi_wvalid  ),
  .s_axi_wready  ( m03_axi_wready  ),
  .s_axi_wdata   ( m03_axi_wdata   ),
  .s_axi_wstrb   ( m03_axi_wstrb   ),
  .s_axi_wlast   ( m03_axi_wlast   ),
  .s_axi_bvalid  ( m03_axi_bvalid  ),
  .s_axi_bready  ( m03_axi_bready  ),
  .s_axi_arvalid ( m03_axi_arvalid ),
  .s_axi_arready ( m03_axi_arready ),
  .s_axi_araddr  ( m03_axi_araddr  ),
  .s_axi_arlen   ( m03_axi_arlen   ),
  .s_axi_rvalid  ( m03_axi_rvalid  ),
  .s_axi_rready  ( m03_axi_rready  ),
  .s_axi_rdata   ( m03_axi_rdata   ),
  .s_axi_rlast   ( m03_axi_rlast   )
);


slv_m03_axi_vip_slv_mem_t   m03_axi;
slv_m03_axi_vip_slv_t   m03_axi_slv;

// Slave MM VIP instantiation
slv_m04_axi_vip inst_slv_m04_axi_vip (
  .aclk          ( ap_clk          ),
  .s_axi_awvalid ( m04_axi_awvalid ),
  .s_axi_awready ( m04_axi_awready ),
  .s_axi_awaddr  ( m04_axi_awaddr  ),
  .s_axi_awlen   ( m04_axi_awlen   ),
  .s_axi_wvalid  ( m04_axi_wvalid  ),
  .s_axi_wready  ( m04_axi_wready  ),
  .s_axi_wdata   ( m04_axi_wdata   ),
  .s_axi_wstrb   ( m04_axi_wstrb   ),
  .s_axi_wlast   ( m04_axi_wlast   ),
  .s_axi_bvalid  ( m04_axi_bvalid  ),
  .s_axi_bready  ( m04_axi_bready  ),
  .s_axi_arvalid ( m04_axi_arvalid ),
  .s_axi_arready ( m04_axi_arready ),
  .s_axi_araddr  ( m04_axi_araddr  ),
  .s_axi_arlen   ( m04_axi_arlen   ),
  .s_axi_rvalid  ( m04_axi_rvalid  ),
  .s_axi_rready  ( m04_axi_rready  ),
  .s_axi_rdata   ( m04_axi_rdata   ),
  .s_axi_rlast   ( m04_axi_rlast   )
);


slv_m04_axi_vip_slv_mem_t   m04_axi;
slv_m04_axi_vip_slv_t   m04_axi_slv;

// Slave MM VIP instantiation
slv_m05_axi_vip inst_slv_m05_axi_vip (
  .aclk          ( ap_clk          ),
  .s_axi_awvalid ( m05_axi_awvalid ),
  .s_axi_awready ( m05_axi_awready ),
  .s_axi_awaddr  ( m05_axi_awaddr  ),
  .s_axi_awlen   ( m05_axi_awlen   ),
  .s_axi_wvalid  ( m05_axi_wvalid  ),
  .s_axi_wready  ( m05_axi_wready  ),
  .s_axi_wdata   ( m05_axi_wdata   ),
  .s_axi_wstrb   ( m05_axi_wstrb   ),
  .s_axi_wlast   ( m05_axi_wlast   ),
  .s_axi_bvalid  ( m05_axi_bvalid  ),
  .s_axi_bready  ( m05_axi_bready  ),
  .s_axi_arvalid ( m05_axi_arvalid ),
  .s_axi_arready ( m05_axi_arready ),
  .s_axi_araddr  ( m05_axi_araddr  ),
  .s_axi_arlen   ( m05_axi_arlen   ),
  .s_axi_rvalid  ( m05_axi_rvalid  ),
  .s_axi_rready  ( m05_axi_rready  ),
  .s_axi_rdata   ( m05_axi_rdata   ),
  .s_axi_rlast   ( m05_axi_rlast   )
);


slv_m05_axi_vip_slv_mem_t   m05_axi;
slv_m05_axi_vip_slv_t   m05_axi_slv;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m00_axi
bit [63:0] axi00_ptr0_ptr = 64'h0;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m01_axi
bit [63:0] axi01_ptr0_ptr = 64'h0;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m02_axi
bit [63:0] axi02_ptr0_ptr = 64'h0;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m03_axi
bit [63:0] axi03_ptr0_ptr = 64'h0;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m04_axi
bit [63:0] axi04_ptr0_ptr = 64'h0;

///////////////////////////////////////////////////////////////////////////
// Pointer for interface : m05_axi
bit [63:0] axi05_ptr0_ptr = 64'h0;

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m00_axi memory.
function void m00_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m00_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m01_axi memory.
function void m01_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m01_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m02_axi memory.
function void m02_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m02_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m03_axi memory.
function void m03_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m03_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m04_axi memory.
function void m04_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m04_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Backdoor fill the m05_axi memory.
function void m05_axi_fill_memory(
  input bit [63:0] ptr,
  input integer    length
);
  for (longint unsigned slot = 0; slot < length; slot++) begin
    m05_axi.mem_model.backdoor_memory_write_4byte(ptr + (slot * 4), slot);
  end
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Control interface non-blocking write
// The task will return when the transaction has been accepted by the driver. It will be some
// amount of time before it will appear on the interface.
task automatic write_register (input bit [31:0] addr_in, input bit [31:0] data);
  axi_transaction   wr_xfer;
  wr_xfer = ctrl.wr_driver.create_transaction("wr_xfer");
  assert(wr_xfer.randomize() with {addr == addr_in;});
  wr_xfer.set_data_beat(0, data);
  ctrl.wr_driver.send(wr_xfer);
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Control interface blocking write
// The task will return when the BRESP has been returned from the kernel.
task automatic blocking_write_register (input bit [31:0] addr_in, input bit [31:0] data);
  axi_transaction   wr_xfer;
  axi_transaction   wr_rsp;
  wr_xfer = ctrl.wr_driver.create_transaction("wr_xfer");
  wr_xfer.set_driver_return_item_policy(XIL_AXI_PAYLOAD_RETURN);
  assert(wr_xfer.randomize() with {addr == addr_in;});
  wr_xfer.set_data_beat(0, data);
  ctrl.wr_driver.send(wr_xfer);
  ctrl.wr_driver.wait_rsp(wr_rsp);
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Control interface blocking read
// The task will return when the BRESP has been returned from the kernel.
task automatic read_register (input bit [31:0] addr, output bit [31:0] rddata);
  axi_transaction   rd_xfer;
  axi_transaction   rd_rsp;
  bit [31:0] rd_value;
  rd_xfer = ctrl.rd_driver.create_transaction("rd_xfer");
  rd_xfer.set_addr(addr);
  rd_xfer.set_driver_return_item_policy(XIL_AXI_PAYLOAD_RETURN);
  ctrl.rd_driver.send(rd_xfer);
  ctrl.rd_driver.wait_rsp(rd_rsp);
  rd_value = rd_rsp.get_data_beat(0);
  rddata = rd_value;
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Poll the Control interface status register.
// This will poll until the DONE flag in the status register is asserted.
task automatic poll_done_register ();
  bit [31:0] rd_value;
  do begin
    read_register(KRNL_CTRL_REG_ADDR, rd_value);
  end while ((rd_value & CONTROL_DONE_MASK) == 0);
endtask

// This will poll until the IDLE flag in the status register is asserted.
task automatic poll_idle_register ();
  bit [31:0] rd_value;
  do begin
    read_register(KRNL_CTRL_REG_ADDR, rd_value);
  end while ((rd_value & CONTROL_IDLE_MASK) == 0);
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Generate a random 32bit number
function bit [31:0] get_random_4bytes();
  bit [31:0] rptr;
  ptr_random_failed: assert(std::randomize(rptr));
  return(rptr);
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Generate a random 64bit 4k aligned address pointer.
function bit [63:0] get_random_ptr();
  bit [63:0] rptr;
  ptr_random_failed: assert(std::randomize(rptr));
  rptr[31:0] &= ~(32'h00000fff);
  return(rptr);
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////
// Write to the control registers to enable the triggering of interrupts for the kernel
task automatic enable_interrupts();
  $display("Starting: Enabling Interrupts....");
  write_register(KRNL_GIE_REG_ADDR, 32'h1);
  write_register(KRNL_IER_REG_ADDR, 32'h1);
  $display("Finished: Interrupts enabled.");
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Disabled the interrupts.
task automatic disable_interrupts();
  $display("Starting: Disable Interrupts....");
  write_register(KRNL_GIE_REG_ADDR, 32'h0);
  write_register(KRNL_IER_REG_ADDR, 32'h0);
  $display("Finished: Interrupts disabled.");
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
//When the interrupt is asserted, read the correct registers and clear the asserted interrupt.
task automatic service_interrupts();
  bit [31:0] rd_value;
  $display("Starting Servicing interrupts....");
  read_register(KRNL_CTRL_REG_ADDR, rd_value);
  $display("Control Register: 0x%0x", rd_value);
  blocking_write_register(KRNL_CTRL_REG_ADDR, rd_value);
  if ((rd_value & CONTROL_DONE_MASK) == 0) begin
    $error("%t : DONE bit not asserted. Register value: (0x%0x)", $time, rd_value);
  end
  read_register(KRNL_ISR_REG_ADDR, rd_value);
  $display("Interrupt Status Register: 0x%0x", rd_value);
  blocking_write_register(KRNL_ISR_REG_ADDR, 32'h1);
  $display("Finished Servicing interrupts");
endtask

bit               error_found = 0;

/////////////////////////////////////////////////////////////////////////////////////////////////
// Start the control VIP and the connected SLAVE memory models.
task automatic start_vips();
  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Control Master: ctrl");
  ctrl = new("ctrl", axonerve_kvs_rtl_exdes_tb_basic.inst_control_axonerve_kvs_rtl_vip.inst.IF);
  ctrl.start_master();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m00_axi");
  m00_axi = new("m00_axi", axonerve_kvs_rtl_exdes_tb_basic.inst_slv_m00_axi_vip.inst.IF);
  m00_axi.start_slave();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m01_axi");
  m01_axi = new("m01_axi", axonerve_kvs_rtl_exdes_tb_basic.inst_slv_m01_axi_vip.inst.IF);
  m01_axi.start_slave();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m02_axi");
  m02_axi = new("m02_axi", axonerve_kvs_rtl_exdes_tb_basic.inst_slv_m02_axi_vip.inst.IF);
  m02_axi.start_slave();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m03_axi");
  m03_axi = new("m03_axi", axonerve_kvs_rtl_exdes_tb_basic.inst_slv_m03_axi_vip.inst.IF);
  m03_axi.start_slave();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m04_axi");
  m04_axi = new("m04_axi", axonerve_kvs_rtl_exdes_tb_basic.inst_slv_m04_axi_vip.inst.IF);
  m04_axi.start_slave();

  $display("///////////////////////////////////////////////////////////////////////////");
  $display("Starting Memory slave: m05_axi");
  m05_axi = new("m05_axi", axonerve_kvs_rtl_exdes_tb_basic.inst_slv_m05_axi_vip.inst.IF);
  m05_axi.start_slave();

endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// For each of the connected slave interfaces, set the Slave to not de-assert WREADY at any time.
// This will show the fastest outbound bandwidth from the WRITE channel.
task automatic slv_no_backpressure_wready();
  axi_ready_gen     rgen;
  $display("%t - Applying slv_no_backpressure_wready", $time);

  rgen = new("m00_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m00_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m01_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m01_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m02_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m02_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m03_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m03_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m04_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m04_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m05_axi_no_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_NO_BACKPRESSURE);
  m05_axi.wr_driver.set_wready_gen(rgen);

endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// For each of the connected slave interfaces, apply a WREADY policy to introduce backpressure.
// Based on the simulation seed the order/shape of the WREADY per-channel will be different.
task automatic slv_random_backpressure_wready();
  axi_ready_gen     rgen;
  $display("%t - Applying slv_random_backpressure_wready", $time);

  rgen = new("m00_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m00_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m01_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m01_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m02_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m02_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m03_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m03_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m04_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m04_axi.wr_driver.set_wready_gen(rgen);

  rgen = new("m05_axi_random_backpressure_wready");
  rgen.set_ready_policy(XIL_AXI_READY_GEN_RANDOM);
  rgen.set_low_time_range(0,12);
  rgen.set_high_time_range(1,12);
  rgen.set_event_count_range(3,5);
  m05_axi.wr_driver.set_wready_gen(rgen);

endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// For each of the connected slave interfaces, force the memory model to not insert any inter-beat
// gaps on the READ channel.
task automatic slv_no_delay_rvalid();
  $display("%t - Applying slv_no_delay_rvalid", $time);

  m00_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m00_axi.mem_model.set_inter_beat_gap(0);

  m01_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m01_axi.mem_model.set_inter_beat_gap(0);

  m02_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m02_axi.mem_model.set_inter_beat_gap(0);

  m03_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m03_axi.mem_model.set_inter_beat_gap(0);

  m04_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m04_axi.mem_model.set_inter_beat_gap(0);

  m05_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_FIXED);
  m05_axi.mem_model.set_inter_beat_gap(0);

endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// For each of the connected slave interfaces, Allow the memory model to insert any inter-beat
// gaps on the READ channel.
task automatic slv_random_delay_rvalid();
  $display("%t - Applying slv_random_delay_rvalid", $time);

  m00_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m00_axi.mem_model.set_inter_beat_gap_range(0,10);

  m01_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m01_axi.mem_model.set_inter_beat_gap_range(0,10);

  m02_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m02_axi.mem_model.set_inter_beat_gap_range(0,10);

  m03_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m03_axi.mem_model.set_inter_beat_gap_range(0,10);

  m04_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m04_axi.mem_model.set_inter_beat_gap_range(0,10);

  m05_axi.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
  m05_axi.mem_model.set_inter_beat_gap_range(0,10);

endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
// Check to ensure, following reset the value of the register is 0.
// Check that only the width of the register bits can be written.
task automatic check_register_value(input bit [31:0] addr_in, input integer unsigned register_width, output bit error_found);
  bit [31:0] rddata;
  bit [31:0] mask_data;
  error_found = 0;
  if (register_width < 32) begin
    mask_data = (1 << register_width) - 1;
  end else begin
    mask_data = 32'hffffffff;
  end
  read_register(addr_in, rddata);
  if (rddata != 32'h0) begin
    $error("Initial value mismatch: A:0x%0x : Expected 0x%x -> Got 0x%x", addr_in, 0, rddata);
    error_found = 1;
  end
  blocking_write_register(addr_in, 32'hffffffff);
  read_register(addr_in, rddata);
  if (rddata != mask_data) begin
    $error("Initial value mismatch: A:0x%0x : Expected 0x%x -> Got 0x%x", addr_in, mask_data, rddata);
    error_found = 1;
  end
endtask


/////////////////////////////////////////////////////////////////////////////////////////////////
// For each of the scalar registers, check:
// * reset value
// * correct number bits set on a write
task automatic check_scalar_registers(output bit error_found);
  bit tmp_error_found = 0;
  error_found = 0;
  $display("%t : Checking post reset values of scalar registers", $time);

  ///////////////////////////////////////////////////////////////////////////
  //Check ID 0: data_num (0x010)
  check_register_value(32'h010, 32, tmp_error_found);
  error_found |= tmp_error_found;

endtask

task automatic set_scalar_registers();
  $display("%t : Setting Scalar Registers registers", $time);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 0: data_num (0x010) -> 32'hffffffff (scalar)
  //write_register(32'h010, 32'hffffffff);
  write_register(32'h010, 32'h16384);

endtask

task automatic check_pointer_registers(output bit error_found);
  bit tmp_error_found = 0;
  ///////////////////////////////////////////////////////////////////////////
  //Check the reset states of the pointer registers.
  $display("%t : Checking post reset values of pointer registers", $time);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 1: axi00_ptr0 (0x018)
  check_register_value(32'h018, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 1: axi00_ptr0 (0x01c)
  check_register_value(32'h01c, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 2: axi01_ptr0 (0x020)
  check_register_value(32'h020, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 2: axi01_ptr0 (0x024)
  check_register_value(32'h024, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 3: axi02_ptr0 (0x028)
  check_register_value(32'h028, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 3: axi02_ptr0 (0x02c)
  check_register_value(32'h02c, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 4: axi03_ptr0 (0x030)
  check_register_value(32'h030, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 4: axi03_ptr0 (0x034)
  check_register_value(32'h034, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 5: axi04_ptr0 (0x038)
  check_register_value(32'h038, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 5: axi04_ptr0 (0x03c)
  check_register_value(32'h03c, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 6: axi05_ptr0 (0x040)
  check_register_value(32'h040, 32, tmp_error_found);
  error_found |= tmp_error_found;

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 6: axi05_ptr0 (0x044)
  check_register_value(32'h044, 32, tmp_error_found);
  error_found |= tmp_error_found;

endtask

task automatic set_memory_pointers();
  ///////////////////////////////////////////////////////////////////////////
  //Randomly generate memory pointers.
  axi00_ptr0_ptr = get_random_ptr();
  axi01_ptr0_ptr = get_random_ptr();
  axi02_ptr0_ptr = get_random_ptr();
  axi03_ptr0_ptr = get_random_ptr();
  axi04_ptr0_ptr = get_random_ptr();
  axi05_ptr0_ptr = get_random_ptr();

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 1: axi00_ptr0 (0x018) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h018, axi00_ptr0_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 1: axi00_ptr0 (0x01c) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h01c, axi00_ptr0_ptr[63:32]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 2: axi01_ptr0 (0x020) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h020, axi01_ptr0_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 2: axi01_ptr0 (0x024) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h024, axi01_ptr0_ptr[63:32]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 3: axi02_ptr0 (0x028) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h028, axi02_ptr0_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 3: axi02_ptr0 (0x02c) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h02c, axi02_ptr0_ptr[63:32]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 4: axi03_ptr0 (0x030) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h030, axi03_ptr0_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 4: axi03_ptr0 (0x034) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h034, axi03_ptr0_ptr[63:32]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 5: axi04_ptr0 (0x038) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h038, axi04_ptr0_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 5: axi04_ptr0 (0x03c) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h03c, axi04_ptr0_ptr[63:32]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 6: axi05_ptr0 (0x040) -> Randomized 4k aligned address (Global memory, lower 32 bits)
  write_register(32'h040, axi05_ptr0_ptr[31:0]);

  ///////////////////////////////////////////////////////////////////////////
  //Write ID 6: axi05_ptr0 (0x044) -> Randomized 4k aligned address (Global memory, upper 32 bits)
  write_register(32'h044, axi05_ptr0_ptr[63:32]);

endtask

task automatic backdoor_fill_memories();

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m00_axi_fill_memory(axi00_ptr0_ptr, LP_MAX_LENGTH);

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m01_axi_fill_memory(axi01_ptr0_ptr, LP_MAX_LENGTH);

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m02_axi_fill_memory(axi02_ptr0_ptr, LP_MAX_LENGTH);

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m03_axi_fill_memory(axi03_ptr0_ptr, LP_MAX_LENGTH);

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m04_axi_fill_memory(axi04_ptr0_ptr, LP_MAX_LENGTH);

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Backdoor fill the memory with the content.
  m05_axi_fill_memory(axi05_ptr0_ptr, LP_MAX_LENGTH);

endtask

function automatic bit check_kernel_result();
  bit [31:0]        ret_rd_value = 32'h0;
  bit error_found = 0;
  integer error_counter;
  error_counter = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m00_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m00_axi.mem_model.backdoor_memory_read_4byte(axi00_ptr0_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m00_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi00_ptr0_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m00_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi00_ptr0_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m00_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m01_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m01_axi.mem_model.backdoor_memory_read_4byte(axi01_ptr0_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m01_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi01_ptr0_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m01_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi01_ptr0_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m01_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m02_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m02_axi.mem_model.backdoor_memory_read_4byte(axi02_ptr0_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m02_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi02_ptr0_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m02_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi02_ptr0_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m02_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m03_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m03_axi.mem_model.backdoor_memory_read_4byte(axi03_ptr0_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m03_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi03_ptr0_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m03_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi03_ptr0_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m03_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m04_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m04_axi.mem_model.backdoor_memory_read_4byte(axi04_ptr0_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m04_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi04_ptr0_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m04_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi04_ptr0_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m04_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // Checking memory connected to m05_axi
  for (longint unsigned slot = 0; slot < LP_MAX_LENGTH; slot++) begin
    ret_rd_value = m05_axi.mem_model.backdoor_memory_read_4byte(axi05_ptr0_ptr + (slot * 4));
    if (slot < LP_MAX_TRANSFER_LENGTH) begin
      if (ret_rd_value != (slot + 1)) begin
        $error("Memory Mismatch: m05_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi05_ptr0_ptr + (slot * 4), slot + 1, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end else begin
      if (ret_rd_value != slot) begin
        $error("Memory Mismatch: m05_axi : @0x%x : Expected 0x%x -> Got 0x%x ", axi05_ptr0_ptr + (slot * 4), slot, ret_rd_value);
        error_found |= 1;
        error_counter++;
      end
    end
    if (error_counter > 5) begin
      $display("Too many errors found. Exiting check of m05_axi.");
      slot = LP_MAX_LENGTH;
    end
  end
  error_counter = 0;

  return(error_found);
endfunction

bit choose_pressure_type = 0;

/////////////////////////////////////////////////////////////////////////////////////////////////
// Set up the kernel for operation and set the kernel START bit.
// The task will poll the DONE bit and check the results when complete.
task automatic multiple_iteration(input integer unsigned num_iterations, output bit error_found);
  error_found = 0;

  $display("Starting: multiple_iteration");
  for (integer unsigned iter = 0; iter < num_iterations; iter++) begin
    $display("Starting iteration: %d / %d", iter+1, num_iterations);
    RAND_WREADY_PRESSURE_FAILED: assert(std::randomize(choose_pressure_type));
    case(choose_pressure_type)
      0: slv_no_backpressure_wready();
      1: slv_random_backpressure_wready();
    endcase
    RAND_RVALID_PRESSURE_FAILED: assert(std::randomize(choose_pressure_type));
    case(choose_pressure_type)
      0: slv_no_delay_rvalid();
      1: slv_random_delay_rvalid();
    endcase
    set_scalar_registers();
    set_memory_pointers();
    backdoor_fill_memories();
    // Check that Kernel is IDLE before starting.
    poll_idle_register();
    ///////////////////////////////////////////////////////////////////////////
    //Start transfers
    write_register(KRNL_CTRL_REG_ADDR, CONTROL_START_MASK);
    ctrl.wait_drivers_idle();
    ///////////////////////////////////////////////////////////////////////////
    //Wait for interrupt being asserted or poll done register
    @(posedge interrupt);
    ///////////////////////////////////////////////////////////////////////////
    // Service the interrupt
    service_interrupts();
    wait(interrupt == 0);
    ///////////////////////////////////////////////////////////////////////////
    error_found |= check_kernel_result()   ;
    $display("Finished iteration: %d / %d", iter+1, num_iterations);
  end
endtask

/////////////////////////////////////////////////////////////////////////////////////////////////
//Instantiate AXI4 LITE VIP
initial begin : STIMULUS
  start_vips();
  check_scalar_registers(error_found);
  if (error_found == 1) begin
    $display( "Test Failed!");
    $finish();
  end
  check_pointer_registers(error_found);
  if (error_found == 1) begin
    $display( "Test Failed!");
    $finish();
  end
  enable_interrupts();
  multiple_iteration(1, error_found);
  if (error_found == 1) begin
    $display( "Test Failed!");
    $finish();
  end
  multiple_iteration(5, error_found);

  if (error_found == 1) begin
    $display( "Test Failed!");
    $finish();
  end else begin
    $display( "Test completed successfully");
  end
  $finish;
end

endmodule
`default_nettype wire

