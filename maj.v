`timescale 1ns/10ps

module maj(
	input a,b,c,
	output o
);

	assign o = (a & b) | (a & c) | (b & c);

endmodule