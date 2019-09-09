`default_nettype none

module search_and_add_sim();

   logic clk;
   logic reset;
   
   logic kick;
   logic busy;

   logic [128+32-1:0] din;
   logic 	      we;
   logic 	      full;

   logic [31:0]       accum_addr;
   logic [128+32-1:0] accum_din;
   logic 	      accum_we;

   initial begin
      clk <= 1'b0;
      forever begin
	 clk <= ~clk;
	 #5;
      end
   end
   
   logic [31:0] counter = 32'h0;
   
   always @(posedge clk) begin
      counter <= counter + 1;

      case (counter)
	
	0: begin
	   reset <= 1'b1;
	end

	10: begin
	   reset <= 1'b0;
	end

	100: begin
	   kick <= 1'b1;
	end
	
	default: begin
	   kick <= 1'b0;
	end
	
      endcase;
      
   end
   

   
   search_and_add U (
		     .clk(clk),
		     .reset(reset),
		     
		     .kick(kick),
		     .busy(busy),
		     
		     .din(din),
		     .we(we),
		     .full(full),
		     
		     .accum_addr(accum_addr),
		     .accum_din(accum_din),
		     .accum_we(accum_we)
		     );

endmodule // search_and_add_sim
   
`default_nettype wire

