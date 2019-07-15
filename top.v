`timescale 1ns/10ps

module top(
	input rx,
	input clk, rst,
	output hs,vs,
	output [2:0]RED,GREEN,
	output [1:0]BLUE
);
	
	wire uart_clk;
	wire vga_clk;
	wire [7:0]data_uart;
	
	clkgen CLKGEN(.clk(clk),.rst(rst),.uart_clk(uart_clk),.vga_clk(vga_clk));
	
	uart UART(.rx(rx),.clk(uart_clk),.rst(rst),.data(data_uart));

	vga_top VGA(.clk(vga_clk),.rst(rst),.hs(hs),.vs(vs),.RED(RED),.GREEN(GREEN),.BLUE(BLUE));

	always @(posedge clk or posedge rst)
	begin
		if (rst)
		begin
			
		end
		else
		begin
			
		end
	end
	
endmodule