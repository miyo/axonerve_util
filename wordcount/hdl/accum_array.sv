`default_nettype none

module accum_array
  #(
    parameter integer ADDR_WIDTH = 14
    )
   (
    input wire 	       clk,
    input wire 	       reset,

    input wire 	       clear_kick,
    output logic       clear_busy,
    
    input wire [31:0]  addr,
    input wire [63:0]  din,
    input wire 	       we,
    output wire [63:0] q
    );

   logic [0:0] 	          ram_wea;
   logic [ADDR_WIDTH-1:0] ram_addra;
   logic [63:0] 	  ram_douta;
   logic [63:0] 	  ram_dina;
			  
   logic [0:0] 		  ram_web;
   logic [ADDR_WIDTH-1:0] ram_addrb;
   logic [63:0] 	  ram_dinb;
   logic [63:0] 	  ram_doutb;

   logic 		  clear_running;
   logic [ADDR_WIDTH-1:0] clear_addr;
   logic [63:0] 	  clear_din;
   logic 		  clear_we;
   
   // It is assumed that each read latency of port A and B is 1-cycle.
   bram_14_64 ram (
		   .clka(clk),
		   .ena(1'b1),
		   .wea(ram_wea),
		   .addra(ram_addra),
		   .dina(ram_dina),
		   .douta(ram_douta),
		   .clkb(clk),
		   .enb(1'b1),
		   .web(ram_web),
		   .addrb(ram_addrb),
		   .dinb(ram_dinb),
		   .doutb(ram_doutb)
		   );

   assign ram_addra  = clear_running ? clear_addr : addr[13:0];
   assign ram_wea[0] = clear_running ? clear_we   : 1'b0;
   assign ram_dina   = clear_running ? clear_din  : 0;
   assign q = ram_douta;

   logic [7:0] 		  clear_state_counter = 0;
   always_ff @(posedge clk) begin
      if(reset == 1) begin
	 clear_running = 0;
	 clear_state_counter = 0;
	 clear_busy = 0;
      end else begin
	 case(clear_state_counter)
	   0: begin
	      if(clear_kick == 1) begin
		 clear_state_counter = clear_state_counter + 1;
		 clear_busy = 1;
		 clear_running = 1;
		 clear_addr = 0;
		 clear_we = 1;
		 clear_din = 0;
	      end else begin
		 clear_busy = 0;
		 clear_running = 0;
		 clear_we = 0;
	      end
	   end // case: 0
	   1: begin
	      if(&(clear_addr[ADDR_WIDTH-1:0]) == 1) begin
		 clear_state_counter <= 0;
	      end
	      clear_addr <= clear_addr + 1;
	      clear_we <= 1;
	      clear_din <= 0;
	   end
	   default : begin
	      clear_running = 0;
	   end
	 endcase
      end
   end // always_ff @ (posedge clk)

   logic 	       we_d0, we_d1, we_d2;
   logic [31:0]        addr_d0, addr_d1, addr_d2;
   logic [63:0]        din_d0;
   logic [31:0]        bypass, bypass_d1;

   logic 	       use_bypass, use_bypass_d1;
      
   always @(posedge clk) begin
      
      if(reset == 1'b1) begin
	 we_d0 <= 1'b0;
	 we_d1 <= 1'b0;
	 we_d2 <= 1'b0;
	 
      end else begin
	 we_d0 <= we;
	 we_d1 <= we_d0;
	 we_d2 <= we_d1;
	 
	 addr_d0 <= addr;
	 addr_d1 <= addr_d0;
	 addr_d2 <= addr_d1;
	 
	 din_d0 <= din;

	 bypass_d1 <= bypass;
	 
	 if(we_d0 == 1'b1) begin
	    ram_web <= 1'b1;
	    ram_addrb <= addr_d0;
	    if(addr_d0 == addr_d1 && we_d1 == 1'b1) begin
	       ram_dinb[63:32] <= din_d0[63:32];
	       ram_dinb[31:0] <= bypass + din_d0[31:0];
	       bypass <= bypass + din_d0[31:0];
	       use_bypass <= 1'b1;
	       use_bypass_d1 <= 1'b0;
	    end else if(addr_d0 == addr_d2 && we_d2 == 1'b1) begin
	       ram_dinb[63:32] <= din_d0[63:32];
	       ram_dinb[31:0] <= bypass_d1 + din_d0[31:0];
	       bypass <= bypass_d1 + din_d0[31:0];
	       use_bypass <= 1'b0;
	       use_bypass_d1 <= 1'b1;
	    end else begin
	       ram_dinb[63:32] <= din_d0[63:32];
	       ram_dinb[31:0] <= ram_douta[31:0] + din_d0[31:0];
	       bypass <= ram_douta + din_d0[31:0];
	       use_bypass <= 1'b0;
	       use_bypass_d1 <= 1'b0;
	    end
	 end else begin
	    ram_web <= 1'b0;
	 end // else: !if(we_d1 == 1'b1)
      end // else: !if(reset == 1'b1)
      
   end // always @ (posedge clk)

endmodule // accum_array

`default_nettype wire
