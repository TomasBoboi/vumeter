`timescale 1ns/10ps

module clk_divider(
	input clk,rst,
	output reg dclk
);

	parameter [9:0]factor = 10'd2; // default division factor = 2
	
	reg [9:0]counter;
	
	always @ (posedge clk or posedge rst) begin
		
		if(rst)begin
			dclk <= 1'b0;
			counter <= 10'd0;
		end
		else begin
			if(counter == factor) begin
				dclk <= 1'b1;
				counter <= 1'b1;
			end
			else begin
				dclk <= 1'b0;
				counter <= counter + 1;
			end
		end
	
	end

endmodule