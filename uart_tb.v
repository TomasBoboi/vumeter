`timescale 1ns/10ps

module uart_tb;
	
	`define BIT_LEN 104166 // 1/9600 -> 104.166 us
	
	reg rx,clk,rst;
	wire [7:0]data;
	wire uart_clk;

	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	clk_divider #(.factor('d652)) uartc(.clk(clk),.rst(rst),.dclk(uart_clk));
	
	initial begin
		rst = 1'b0;
		rx = 1'b1;
		
		#25 rst = !rst;
		#25 rst = !rst;
		
		/// FIRST PACKET
		
		/// start bit
		#100 rx = 1'b0;
		
		/// data bits
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+4)  rx = 1'b0;
		#(`BIT_LEN-3)  rx = 1'b0;
		#(`BIT_LEN+3)  rx = 1'b1;
		#(`BIT_LEN+1)  rx = 1'b1;
		#(`BIT_LEN-2)  rx = 1'b0;
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+1)  rx = 1'b0;
		
		/// parity bit
		#(`BIT_LEN+1)  rx = 1'b0;
		
		/// stop bit
		#(`BIT_LEN-2)  rx = 1'b1;
		
		/// END OF FIRST PACKET
		
		/// SECOND PACKET
		
		/// start bit
		#(5*(`BIT_LEN+1)) rx = 1'b0;
		
		/// data bits
		#(`BIT_LEN+1)  rx = 1'b0;
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+3)  rx = 1'b0;
		#(`BIT_LEN+1)  rx = 1'b1;
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+3)  rx = 1'b1;
		#(`BIT_LEN+1)  rx = 1'b0;
		#(`BIT_LEN+2)  rx = 1'b1;
		
		/// parity bit
		#(`BIT_LEN+3)  rx = 1'b1;
		
		/// stop bit
		#(`BIT_LEN+1)  rx = 1'b1;
		
		/// END OF SECOND PACKET
		
		/// THIRD PACKET
		
		/// start bit
		#(5*(`BIT_LEN-1)) rx = 1'b0;
		
		/// data bits
		#(`BIT_LEN-2)  rx = 1'b1;
		#(`BIT_LEN-4)  rx = 1'b1;
		#(`BIT_LEN-1)  rx = 1'b1;
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+3)  rx = 1'b1;
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN-1)  rx = 1'b0;
		#(`BIT_LEN-2)  rx = 1'b1;
		
		/// parity bit
		#(`BIT_LEN+1)  rx = 1'b1;
		
		/// stop bit
		#(`BIT_LEN+2)  rx = 1'b1;
		
		/// END OF THIRD PACKET
		
	end
	
	uart DUT(.rx(rx),.clk(uart_clk),.rst(rst),.data(data));

endmodule