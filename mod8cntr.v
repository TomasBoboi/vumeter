`timescale 1ns/1ns

module mod8cntr(
	input clk,rst,enable,
	output [3:0]count
);

	reg [3:0]count_ff,count_nxt;
	
	assign count = count_ff;

	always @ (*)
	begin 
		count_nxt = count_ff;
		if(enable)
			count_nxt = count_ff + 1'b1;
	end

	always @ (posedge clk or posedge rst)
	begin
		if(rst)
			count_ff <= 'd0;
		else count_ff <= count_nxt;
	end

endmodule