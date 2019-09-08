module accum_array_sim( );
  
   logic clk   = 1'b0;
   logic reset = 1'b0;
   
   logic [31:0] addr = 32'd0;
   logic [63:0] din  = 32'd0;
   logic [0:0] 	we   = 1'b0;
   logic [63:0] q;

   accum_array U (
		 .clk(clk),
		 .reset(reset),
    
		 .addr(addr),
		 .din(din),
		 .we(we),
		 .q(q)
		 );
   
   initial begin
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
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	101: begin
	   addr <= 32'd1;
	   din[63:32] <= 32'hABADCAFE;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	102: begin
	   addr <= 32'd2;
	   din[63:32] <= 32'hFEFEFEFE;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	103: begin
	   addr <= 32'd3;
	   din[63:32] <= 32'h34343434;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	104: begin
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	105: begin
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	106: begin
	   addr <= 32'd1;
	   din[63:32] <= 32'hABADCAFE;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	107: begin
	   addr <= 32'd1;
	   din[63:32] <= 32'hABADCAFE;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	108: begin
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	109: begin
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	110: begin
	   addr <= 32'd3;
	   din[63:32] <= 32'h34343434;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	111: begin
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	112: begin
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	
	
	500: begin
	   addr <= 32'd0;
	end
	501: begin
	   addr <= 32'd1;
	end
	502: begin
	   addr <= 32'd2;
	end
	503: begin
	   addr <= 32'd3;
	end

	default: begin
	   we <= 1'b0;
	end
	
      endcase // case (counter)
      
   end // always @ (posedge clk)

endmodule // accum_array_sim
