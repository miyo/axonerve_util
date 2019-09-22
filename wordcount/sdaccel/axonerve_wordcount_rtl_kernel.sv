`default_nettype none
module axonerve_wordcount_rtl_kernel #(
  parameter integer C_M_AXI_ADDR_WIDTH = 64,
  parameter integer C_M_AXI_DATA_WIDTH = 512,
  parameter integer C_M00_AXI_ADDR_WIDTH = 64,
  parameter integer C_M00_AXI_DATA_WIDTH = 512,
  parameter integer C_XFER_SIZE_WIDTH = 32,
  parameter integer C_ADDER_BIT_WIDTH = 32
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
localparam integer LP_NUM_EXAMPLES = 1;
localparam integer LP_DW_BYTES             = C_M_AXI_DATA_WIDTH/8;
localparam integer LP_AXI_BURST_LEN        = 4096/LP_DW_BYTES < 256 ? 4096/LP_DW_BYTES : 256;
localparam integer LP_LOG_BURST_LEN        = $clog2(LP_AXI_BURST_LEN);
localparam integer LP_BRAM_DEPTH           = 512;
localparam integer LP_RD_MAX_OUTSTANDING   = LP_BRAM_DEPTH / LP_AXI_BURST_LEN;
localparam integer LP_WR_MAX_OUTSTANDING   = 32;
   
logic kernel_clk;
logic kernel_rst;

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////
(* KEEP = "yes" *)
logic                                areset                         = 1'b0;
logic                                ap_start_r                     = 1'b0;
logic                                ap_idle_r                      = 1'b1;
logic                                ap_start_pulse                ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_i                     ;
logic [LP_NUM_EXAMPLES-1:0]          ap_done_r                      = {LP_NUM_EXAMPLES{1'b0}};

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
     ap_idle_r <= ~wordcount_busy ? 1'b0 :
		  ap_done ? 1'b1 :
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

assign kernel_clk = ap_clk;
assign kernel_rst = areset;

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

   assign wordcount_kick = ap_start_pulse;
   assign ap_done_i[0] = ~wordcount_busy;

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

   axonerve_wordcount_rtl_example_axi_read_master #(
						    .C_M_AXI_ADDR_WIDTH  ( C_M00_AXI_ADDR_WIDTH    ) ,
						    .C_M_AXI_DATA_WIDTH  ( C_M00_AXI_DATA_WIDTH    ) ,
						    .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
						    .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
						    .C_INCLUDE_DATA_FIFO ( 1                     )
						    )
   inst_axi_read_master (
			 .aclk                    ( ap_clk                  ) ,
			 .areset                  ( areset                  ) ,
			 .ctrl_start              ( reader_ctrl_start       ) ,
			 .ctrl_done               ( reader_ctrl_done        ) ,
			 .ctrl_addr_offset        ( reader_ctrl_addr_offset ) ,
			 .ctrl_xfer_size_in_bytes ( reader_ctrl_xfer_size_in_bytes ) ,
			 .m_axi_arvalid           ( m00_axi_arvalid           ) ,
			 .m_axi_arready           ( m00_axi_arready           ) ,
			 .m_axi_araddr            ( m00_axi_araddr            ) ,
			 .m_axi_arlen             ( m00_axi_arlen             ) ,
			 .m_axi_rvalid            ( m00_axi_rvalid            ) ,
			 .m_axi_rready            ( m00_axi_rready            ) ,
			 .m_axi_rdata             ( m00_axi_rdata             ) ,
			 .m_axi_rlast             ( m00_axi_rlast             ) ,
			 .m_axis_aclk             ( kernel_clk                ) ,
			 .m_axis_areset           ( kernel_rst                ) ,
			 .m_axis_tvalid           ( reader_s_axis_tvalid      ) ,
			 .m_axis_tready           ( reader_s_axis_tready      ) ,
			 .m_axis_tlast            ( reader_s_axis_tlast       ) ,
			 .m_axis_tdata            ( reader_s_axis_tdata       )
			 );


   axonerve_wordcount_rtl_example_axi_write_master #(
						     .C_M_AXI_ADDR_WIDTH  ( C_M_AXI_ADDR_WIDTH    ) ,
						     .C_M_AXI_DATA_WIDTH  ( C_M_AXI_DATA_WIDTH    ) ,
						     .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
						     .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
						     .C_INCLUDE_DATA_FIFO ( 1                     )
						     )
   inst_axi_write_master (
			  .aclk                    ( ap_clk                  ) ,
			  .areset                  ( areset                  ) ,
			  .ctrl_start              ( writer_ctrl_start       ) ,
			  .ctrl_done               ( writer_ctrl_done        ) ,
			  .ctrl_addr_offset        ( writer_ctrl_addr_offset ) ,
			  .ctrl_xfer_size_in_bytes ( writer_ctrl_xfer_size_in_bytes ) ,
			  .m_axi_awvalid           ( m00_axi_awvalid         ) ,
			  .m_axi_awready           ( m00_axi_awready         ) ,
			  .m_axi_awaddr            ( m00_axi_awaddr          ) ,
			  .m_axi_awlen             ( m00_axi_awlen           ) ,
			  .m_axi_wvalid            ( m00_axi_wvalid          ) ,
			  .m_axi_wready            ( m00_axi_wready          ) ,
			  .m_axi_wdata             ( m00_axi_wdata           ) ,
			  .m_axi_wstrb             ( m00_axi_wstrb           ) ,
			  .m_axi_wlast             ( m00_axi_wlast           ) ,
			  .m_axi_bvalid            ( m00_axi_bvalid          ) ,
			  .m_axi_bready            ( m00_axi_bready          ) ,
			  .s_axis_aclk             ( kernel_clk              ) ,
			  .s_axis_areset           ( kernel_rst              ) ,
			  .s_axis_tvalid           ( writer_m_axis_tvalid    ) ,
			  .s_axis_tready           ( writer_m_axis_tready    ) ,
			  .s_axis_tdata            ( writer_m_axis_tdata     )
			  );
   
endmodule : axonerve_wordcount_rtl_kernel

`default_nettype wire

