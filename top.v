`timescale 1ns/10ps

module top(
	input rx,
	input clk,rst,
	output hs,vs,
	output [2:0]RED,GREEN,
	output [1:0]BLUE
);
	
	wire uart_clk;
	wire vga_clk;
	wire [7:0]data_uart;
	wire data_valid;

	wire [63:0]data_left,data_right;
	
	clkgen CLKGEN(.clk(clk),.rst(rst),.uart_clk(uart_clk),.vga_clk(vga_clk));
	
	uart UART(.rx(rx),.clk(uart_clk),.rst(rst),.data(data_uart),.data_valid(data_valid));

	fifo LEFT(.clk(data_valid),.rst(rst),.data_in(data_uart),.data_out(data_left));
	fifo RIGHT(.clk(data_valid),.rst(rst),.data_in(data_uart),.data_out(data_right));

	vga_top VGA(.clk(vga_clk),.rst(rst),.data({data_left,data_right}),.o_hs(hs),.o_vs(vs),.RED(RED),.GREEN(GREEN),.BLUE(BLUE));
	
endmodule