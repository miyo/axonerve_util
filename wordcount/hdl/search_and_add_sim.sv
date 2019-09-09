`timescale 1ns/1ps
`default_nettype none

module search_and_add_sim();

   logic clk = 1'b0;
   logic reset;
   logic ready;
   
   logic kick;
   logic busy;

   logic [128+32-1:0] din;
   logic 	      we = 1'b0;
   logic 	      full;
   logic [7:0] 	      data_num = 8'd0;

   logic [31:0]       accum_addr;
   logic [63:0]       accum_din;
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

      case (counter)
	
	0: begin
	   reset <= 1'b1;
           we <= 1'b0;
	   counter <= counter + 1;
	end

	10: begin
	   reset <= 1'b0;
	   counter <= counter + 1;
	end

	12: begin
	   if(ready == 1'b1) begin
	      counter <= counter + 1;
	   end
	end

	20: begin
	    we <= 1'b1;
            din <= {32'hDEADBEEF, 32'hABADCAFE, 32'hFEFEFEFE, 32'h34343434, 32'h5a5a5a5a};
	   counter <= counter + 1;
	end
	21: begin
	    we <= 1'b1;
            din <= {32'h00C0FFEE, 32'h01234567, 32'h89abcdef, 32'h01234567, 32'h89abcdef};
	   counter <= counter + 1;
	end

	22: begin
	   we <= 1'b0;
	   kick <= 1'b1;
	   data_num <= 2;
	   counter <= counter + 1;
	end

	23: begin
	   we <= 1'b0;
	   kick <= 1'b0;
           if(kick == 0 && busy == 0) begin
	       counter <= counter + 1;
           end 
	end
	
	30: begin
	    we <= 1'b1;
            din <= {32'hDEADBA11, 32'hABADCAFE, 32'hFEFEFEFE, 32'h34343434, 32'h5a5a5a5a};
	   counter <= counter + 1;
	end
	31: begin
	   we <= 1'b0;
	   kick <= 1'b1;
	   data_num <= 1;
	   counter <= counter + 1;
	end
	32: begin
	   we <= 1'b0;
	   kick <= 1'b0;
           if(kick == 0 && busy == 0) begin
	       counter <= counter + 1;
           end 
	end

	40: begin
	   we <= 1'b1;
           din <= {32'h11C0FFEE, 32'h01234567, 32'h89abcdef, 32'h01234567, 32'h89abcdef};
	   counter <= counter + 1;
	end
	41: begin
	   we <= 1'b1;
           din <= {32'hDEADBEEF, 32'hABADCAFE, 32'hFEFEFEFE, 32'h34343434, 32'h5a5a5a5a};
	   counter <= counter + 1;
	end
	42: begin
	   we <= 1'b0;
	   kick <= 1'b1;
	   data_num <= 2;
	   counter <= counter + 1;
	end

	default: begin
	   kick <= 1'b0;
           we <= 1'b0;
	   counter <= counter + 1;
	end
	
      endcase;
      
   end
   

   
   search_and_add U (
		     .clk(clk),
		     .reset(reset),
		     .ready(ready),
		     
		     .kick(kick),
		     .busy(busy),
		     
		     .din(din),
		     .we(we),
		     .full(full),
		     .data_num(data_num),
		     
		     .accum_addr(accum_addr),
		     .accum_din(accum_din),
		     .accum_we(accum_we)
		     );

endmodule // search_and_add_sim
   
`default_nettype wire

