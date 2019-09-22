module accum_array_sim( );
  
   logic clk   = 1'b0;
   logic reset = 1'b0;
   
   logic [31:0] addr = 32'd0;
   logic [63:0] din  = 32'd0;
   logic [0:0] 	we   = 1'b0;
   logic [63:0] q;

   logic 	clear_kick = 0;
   logic 	clear_busy;

   accum_array U (
		  .clk(clk),
		  .reset(reset),
		  
		  .clear_kick(clear_kick),
		  .clear_busy(clear_busy),
		  
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
   logic 	error_flag = 1'b0;

   always @(posedge clk) begin

      case (counter)
	
	0: begin
	   counter <= counter + 1;
	   reset <= 1'b1;
	   error_flag <= 1'b0;
	   clear_kick <= 1'b0;
	end
	
	10: begin
	   counter <= counter + 1;
	   reset <= 1'b0;
	end

	100: begin
	   counter <= counter + 1;
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	101: begin
	   counter <= counter + 1;
	   addr <= 32'd1;
	   din[63:32] <= 32'hABADCAFE;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	102: begin
	   counter <= counter + 1;
	   addr <= 32'd2;
	   din[63:32] <= 32'hFEFEFEFE;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	103: begin
	   counter <= counter + 1;
	   addr <= 32'd3;
	   din[63:32] <= 32'h34343434;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	104: begin
	   counter <= counter + 1;
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	105: begin
	   counter <= counter + 1;
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	106: begin
	   counter <= counter + 1;
	   addr <= 32'd1;
	   din[63:32] <= 32'hABADCAFE;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	107: begin
	   counter <= counter + 1;
	   addr <= 32'd1;
	   din[63:32] <= 32'hABADCAFE;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	108: begin
	   counter <= counter + 1;
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	109: begin
	   counter <= counter + 1;
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	110: begin
	   counter <= counter + 1;
	   addr <= 32'd3;
	   din[63:32] <= 32'h34343434;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	111: begin
	   counter <= counter + 1;
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	112: begin
	   counter <= counter + 1;
	   addr <= 32'd0;
	   din[63:32] <= 32'hDEADBEEF;
	   din[31:0] <= 32'd1;
	   we <= 1'b1;
	end
	
	
	499: begin
	   counter <= counter + 1;
	   addr <= 32'hFFFFFFFF;
	end
	500: begin
	   counter <= counter + 1;
	   addr <= 32'd0;
	end
	501: begin
	   counter <= counter + 1;
	   addr <= 32'd1;
	end
	502: begin
	   counter <= counter + 1;
	   if(q != {32'hDEADBEEF, 32'h0000007}) begin
	      error_flag <= 1'b1;
	   end
	   addr <= 32'd2;
	end
	503: begin
	   counter <= counter + 1;
	   if(q != {32'hABADCAFE, 32'h0000003}) begin
	      error_flag <= 1'b1;
	   end
	   addr <= 32'd3;
	end
	504: begin
	   counter <= counter + 1;
	   if(q != {32'hFEFEFEFE, 32'h0000001}) begin
	      error_flag <= 1'b1;
	   end
	end
	505: begin
	   counter <= counter + 1;
	   if(q != {32'h34343434, 32'h0000002}) begin
	      error_flag <= 1'b1;
	   end
	end

	508: begin
	   counter <= counter + 1;
	   clear_kick <= 1'b1;
	end
	509: begin
	   clear_kick <= 1'b0;
	   if(clear_busy == 0 && clear_kick == 0) begin
	      counter <= counter + 1;
	   end
	end
	
	599: begin
	   counter <= counter + 1;
	   addr <= 32'hFFFFFFFF;
	end
	600: begin
	   counter <= counter + 1;
	   addr <= 32'd0;
	end
	601: begin
	   counter <= counter + 1;
	   addr <= 32'd1;
	end
	602: begin
	   counter <= counter + 1;
	   if(q != 0) begin
	      error_flag <= 1'b1;
	   end
	   addr <= 32'd2;
	end
	603: begin
	   counter <= counter + 1;
	   if(q != 0) begin
	      error_flag <= 1'b1;
	   end
	   addr <= 32'd3;
	end
	604: begin
	   counter <= counter + 1;
	   if(q != 0) begin
	      error_flag <= 1'b1;
	   end
	end
	605: begin
	   counter <= counter + 1;
	   if(q != 0) begin
	      error_flag <= 1'b1;
	   end
	end

	700: begin
	   $finish;
	end

	default: begin
	   we <= 1'b0;
	   counter <= counter + 1;
	end
	
      endcase // case (counter)
      
   end // always @ (posedge clk)

endmodule // accum_array_sim
