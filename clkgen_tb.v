`timescale 1ns/1ps

module clkgen_tb;

	reg clk, rst;
	
	initial begin
	
		clk = 1'b0;
		rst = 1'b0;
		
		forever #5 clk = ~clk;
	
	end
	
	initial begin
	
		#5 rst = ~rst;
		#10 rst = ~rst;
	
	end
	
	clkgen DUT(.clk(clk),.rst(rst),.uart_clk(uart_clk),.vga_clk(vga_clk));

endmodule