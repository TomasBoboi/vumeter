`timescale 1ns/1ps

module clkgen(
	input clk, rst,
	output uart_clk, vga_clk 
);
	/// NEXYS3 CLOCK: 100 MHz

	/// UART CLOCK: 9600 * 16 = 153600 Hz - factor = 651
	// baud 115200 - factor 54.25
	
	clk_divider #(.factor('d54)) UART_CLK_DIVIDER(.clk(clk),.rst(rst),.dclk(uart_clk));
	
	/// VGA CLOCK: 25 MHZ (480x640) - factor = 4
	
	clk_divider #(.factor(10'd4)) VGA_CLK_DIVIDER(.clk(clk),.rst(rst),.dclk(vga_clk));
	
endmodule