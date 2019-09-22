`default_nettype none

module accum_array_clear_sim();

   logic clk = 0;
   logic reset;

   logic clear_kick;
   logic clear_busy;
    
   logic [31:0] addr;
   logic [63:0] din;
   logic 	we;
   logic [63:0] q;

   initial begin
      clk <= 1'b0;
      forever begin
	 clk <= ~clk;
	 #5;
      end
   end

   logic [31:0] counter = 32'h0;
   
   always @(posedge clk) begin
      
      case(counter)
	0 : begin
	   reset <= 1;
	   clear_kick <= 0;
	   counter <= counter + 1;
	end

	10 : begin
	   reset <= 0;
	   counter <= counter + 1;
	end
	
	20 : begin
	   clear_kick <= 1;
	   counter <= counter + 1;
	end
	21 : begin
	   clear_kick <= 0;
	   if(clear_kick == 0 && clear_busy == 0) begin
	      counter <= counter + 1;
	   end
	end

	30: begin
	   $finish;
	end
	
	default: begin
	   counter <= counter + 1;
	end
      endcase // case (counter)
      
   end

  
   accum_array#(.ADDR_WIDTH(14))
   dut (
	.clk(clk),
	.reset(reset),

	.clear_kick(clear_kick),
	.clear_busy(clear_busy),
    
	.addr(addr),
	.din(din),
	.we(we),
	.q(q)
    );
   

endmodule // accum_array

`default_nettype wire
