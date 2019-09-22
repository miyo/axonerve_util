`default_nettype wire

module axonerve_wordcount_rtl_kernel_sim();

   localparam C_M_AXI_ADDR_WIDTH = 64;
   localparam C_M_AXI_DATA_WIDTH = 512;
   localparam C_M00_AXI_ADDR_WIDTH = 64;
   localparam C_M00_AXI_DATA_WIDTH = 512;
   localparam C_XFER_SIZE_WIDTH = 32;
   localparam C_ADDER_BIT_WIDTH = 32;

   logic ap_clk = 0;
   logic ap_rst_n;
   
   logic m00_axi_awvalid;
   logic m00_axi_awready;
   logic [C_M00_AXI_ADDR_WIDTH-1:0] m00_axi_awaddr;
   logic [8-1:0] 		    m00_axi_awlen;
   logic 			    m00_axi_wvalid;
   logic			    m00_axi_wready;
   logic [C_M00_AXI_DATA_WIDTH-1:0] m00_axi_wdata;
   logic [C_M00_AXI_DATA_WIDTH/8-1:0] m00_axi_wstrb;
   logic			      m00_axi_wlast;
   logic 			      m00_axi_bvalid;
   logic			      m00_axi_bready;
   logic 			      m00_axi_arvalid;
   logic 			      m00_axi_arready;
   logic [C_M00_AXI_ADDR_WIDTH-1:0]   m00_axi_araddr;
   logic [8-1:0] 		      m00_axi_arlen;
   logic			      m00_axi_rvalid;
   logic			      m00_axi_rready;
   logic [C_M00_AXI_DATA_WIDTH-1:0]   m00_axi_rdata;
   logic			      m00_axi_rlast;
   // SDx Control Signals
   logic 			      ap_start;
   logic 			      ap_idle;
   logic 			      ap_done;
   logic [32-1:0] 		      data_num;
   logic [32-1:0] 		      command;
   logic [64-1:0] 		      axi00_ptr0;

   initial begin
      forever begin
	 ap_clk <= ~ap_clk;
	 #5;
      end
   end

   logic [31:0] counter = 32'h0;

   always @(posedge ap_clk) begin

      case (counter)
	
	0: begin
	   counter <= counter + 1;
	   ap_rst_n <= 0;
	   ap_start <= 0;
	end
	
	10: begin
	   counter <= counter + 1;
	   ap_rst_n <= 1;
	end

	16: begin
	   if(ap_idle == 1) begin
	      counter <= counter + 1;
	   end
	end
	
	18: begin
	   ap_start <= 1;
	   command <= 3;
	   counter <= counter + 1;
	end
	19: begin
	   ap_start <= 0;
	   if(ap_done == 1) begin
	      counter <= counter + 1;
	   end
	end

	default: begin
	   counter <= counter + 1;
	end
	
      endcase // case (counter)

   end
   
   axonerve_wordcount_rtl_kernel#(.C_M_AXI_ADDR_WIDTH(C_M_AXI_ADDR_WIDTH),
				  .C_M_AXI_DATA_WIDTH(C_M_AXI_DATA_WIDTH),
				  .C_M00_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
				  .C_M00_AXI_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
				  .C_XFER_SIZE_WIDTH(C_XFER_SIZE_WIDTH),
				  .C_ADDER_BIT_WIDTH(C_ADDER_BIT_WIDTH)
				  )
   dut (
	.ap_clk(ap_clk),
	.ap_rst_n(ap_rst_n),
	.m00_axi_awvalid(m00_axi_awvalid),
	.m00_axi_awready(m00_axi_awready),
	.m00_axi_awaddr(m00_axi_awaddr),
	.m00_axi_awlen(m00_axi_awlen),
	.m00_axi_wvalid(m00_axi_wvalid),
	.m00_axi_wready(m00_axi_wready),
	.m00_axi_wdata(m00_axi_wdata),
	.m00_axi_wstrb(m00_axi_wstrb),
	.m00_axi_wlast(m00_axi_wlast),
	.m00_axi_bvalid(m00_axi_bvalid),
	.m00_axi_bready(m00_axi_bready),
	.m00_axi_arvalid(m00_axi_arvalid),
	.m00_axi_arready(m00_axi_arready),
	.m00_axi_araddr(m00_axi_araddr),
	.m00_axi_arlen(m00_axi_arlen),
	.m00_axi_rvalid(m00_axi_rvalid),
	.m00_axi_rready(m00_axi_rready),
	.m00_axi_rdata(m00_axi_rdata),
	.m00_axi_rlast(m00_axi_rlast),
	.ap_start(ap_start),
	.ap_idle(ap_idle),
	.ap_done(ap_done),
	.data_num(data_num),
	.command(command),
	.axi00_ptr0(axi00_ptr0)
	);
   
endmodule // axonerve_wordcount_rtl_kernel_sim

