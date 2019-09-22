`default_nettype none
module axonerve_wordcount_rtl_kernel #(
  parameter integer C_M00_AXI_ADDR_WIDTH = 64 ,
  parameter integer C_M00_AXI_DATA_WIDTH = 512
)
(
  // System Signals
  input  wire                              ap_clk         ,
  input  wire                              ap_rst_n       ,
  // AXI4 master interface m00_axi
  output wire                              m00_axi_awvalid,
  input  wire                              m00_axi_awready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_awaddr ,
  output wire [8-1:0]                      m00_axi_awlen  ,
  output wire                              m00_axi_wvalid ,
  input  wire                              m00_axi_wready ,
  output wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_wdata  ,
  output wire [C_M00_AXI_DATA_WIDTH/8-1:0] m00_axi_wstrb  ,
  output wire                              m00_axi_wlast  ,
  input  wire                              m00_axi_bvalid ,
  output wire                              m00_axi_bready ,
  output wire                              m00_axi_arvalid,
  input  wire                              m00_axi_arready,
  output wire [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_araddr ,
  output wire [8-1:0]                      m00_axi_arlen  ,
  input  wire                              m00_axi_rvalid ,
  output wire                              m00_axi_rready ,
  input  wire [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_rdata  ,
  input  wire                              m00_axi_rlast  ,
  // SDx Control Signals
  input  wire                              ap_start       ,
  output wire                              ap_idle        ,
  output wire                              ap_done        ,
  input  wire [32-1:0]                     data_num       ,
  input  wire [32-1:0]                     command        ,
  input  wire [64-1:0]                     axi00_ptr0     
);


timeunit 1ps;
timeprecision 1ps;

///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
// Large enough for interesting traffic.
localparam integer  LP_DEFAULT_LENGTH_IN_BYTES = 16384;
localparam integer  LP_NUM_EXAMPLES    = 1;

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////
(* KEEP = "yes" *)
logic                                areset                         = 1'b0;
logic                                kernel_rst                     = 1'b0;
logic                                ap_start_r                     = 1'b0;
logic                                ap_idle_r                      = 1'b1;
logic                                ap_start_pulse                ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_i                     ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_r                      = {LP_NUM_EXAMPLES{1'b0}};
logic [32-1:0]                       ctrl_xfer_size_in_bytes        = LP_DEFAULT_LENGTH_IN_BYTES;
logic [32-1:0]                       ctrl_constant                  = 32'd1;

///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////

// Register and invert reset signal.
always @(posedge ap_clk) begin
  areset <= ~ap_rst_n;
end

// create pulse when ap_start transitions to 1
always @(posedge ap_clk) begin
  begin
    ap_start_r <= ap_start;
  end
end

assign ap_start_pulse = ap_start & ~ap_start_r;

// ap_idle is asserted when done is asserted, it is de-asserted when ap_start_pulse
// is asserted
always @(posedge ap_clk) begin
  if (areset) begin
    ap_idle_r <= 1'b1;
  end
  else begin
    ap_idle_r <= ap_done ? 1'b1 :
      ap_start_pulse ? 1'b0 : ap_idle;
  end
end

assign ap_idle = ap_idle_r;

// Done logic
always @(posedge ap_clk) begin
  if (areset) begin
    ap_done_r <= '0;
  end
  else begin
    ap_done_r <= (ap_start_pulse | ap_done) ? '0 : ap_done_r | ap_done_i;
  end
end

assign ap_done = &ap_done_r;
assign kernel_rst = areset;

//`define WITH_ORIGINAL_TESTBENCH
   
`ifndef WITH_ORIGINAL_TESTBENCH
   always @(posedge ap_clk) begin
      ctrl_xfer_size_in_bytes <= data_num;
   end
`endif

   logic 			    wordcount_kick;
   logic 			    wordcount_busy;

   // to/from axonerve_kvs_rtl_example_axi_read_master
   logic  			    reader_ctrl_start;
   logic 			    reader_ctrl_done;
   logic [64-1:0] 		    reader_ctrl_addr_offset;
   logic [64-1:0] 		    reader_ctrl_xfer_size_in_bytes;
   logic			    reader_s_axis_tvalid;
   logic 			    reader_s_axis_tready;
   logic [512-1:0] 		    reader_s_axis_tdata;
   logic 			    reader_s_axis_tlast;
  
   // to/from axonerve_kvs_rtl_example_axi_write_master
   logic			    writer_ctrl_start;
   logic			    writer_ctrl_done;
   logic [64-1:0] 		    writer_ctrl_addr_offset;
   logic [64-1:0] 		    writer_ctrl_xfer_size_in_bytes;
   logic 			    writer_m_axis_tvalid;
   logic 			    writer_m_axis_tready;
   logic [512-1:0] 		    writer_m_axis_tdata;

   wordcout_top wordcount_top_i
     (
      .clk(ap_clk),
      .reset(areset),
      
      .kick(wordcount_kick),
      .busy(wordcount_busy),
      
      // scalar parameters
      .command(command),
      .num_of_words(data_num),
      .global_memory_offset(axi00_ptr0),
      
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

endmodule : axonerve_kvs_rtl_example
`default_nettype wire

