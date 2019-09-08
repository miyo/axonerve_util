`default_nettype none

module accum_array
  #(
    parameter integer ADDR_WIDTH = 14
    )
   (
    input wire 	       clk,
    input wire 	       reset,
    
    input wire [31:0]  addr,
    input wire [63:0]  din,
    input wire 	       we,
    output wire [63:0] q
    );

   logic [13:0]        ram_addra;
   logic [63:0]        ram_douta;
   
   logic [0:0] 	       ram_web;
   logic [13:0]        ram_addrb;
   logic [63:0]        ram_dinb;
   logic [63:0]        ram_doutb;

   // It is assumed that each read latency of port A and B is 1-cycle.
   bram_14_64 ram (
		   .clka(clk),
		   .ena(1'b1),
		   .wea(1'b0),
		   .addra(ram_addra),
		   .dina(64'd0),
		   .douta(ram_douta),
		   .clkb(clk),
		   .enb(1'b1),
		   .web(ram_web),
		   .addrb(ram_addrb),
		   .dinb(ram_dinb),
		   .doutb(ram_doutb)
		   );

   assign ram_addra = addr[13:0];
   assign q = ram_douta;

   logic 	       we_d0, we_d1;
   logic [31:0]        addr_d0, addr_d1;
   logic [63:0]        din_d0;
   logic [31:0]        bypass;

   logic 	       use_bypass;
   
   always @(posedge clk) begin
      
      if(reset == 1'b1) begin
	 we_d0 <= 1'b0;
	 we_d1 <= 1'b0;
	 
      end else begin
	 we_d0 <= we;
	 we_d1 <= we_d0;
	 
	 addr_d0 <= addr;
	 addr_d1 <= addr_d0;
	 
	 din_d0 <= din;
	 
	 if(we_d0 == 1'b1) begin
	    ram_web <= 1'b1;
	    ram_addrb <= addr_d0;
	    if(addr_d0 == addr_d1 && we_d1 == 1'b1) begin
	       ram_dinb[63:32] <= din_d0[63:32];
	       ram_dinb[31:0] <= bypass + din_d0[31:0];
	       bypass <= bypass + din_d0[31:0];
	       use_bypass <= 1'b1;
	    end else begin
	       ram_dinb[63:32] <= din_d0[63:32];
	       ram_dinb[31:0] <= ram_douta[31:0] + din_d0[31:0];
	       bypass <= ram_douta + din_d0[31:0];
	       use_bypass <= 1'b0;
	    end
	 end else begin
	    ram_web <= 1'b0;
	 end // else: !if(we_d1 == 1'b1)
      end // else: !if(reset == 1'b1)
      
   end // always @ (posedge clk)

endmodule // accum_array

`default_nettype wire
