`timescale 1ns/10ps

module top_tb;
	
	reg clk,rst;
	
	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk; /// 100 MHz freq -> 10ns period -> 5ns half-period
	end
	
	// UART TESTBENCH
	
	`define BIT_LEN 104166 /// 1/115200 -> 8.680 us
	
	reg rx;
	wire [7:0]data;

	initial begin
		rst = 1'b0;
		rx = 1'b1;
		
		#25 rst = !rst;
		#25 rst = !rst;
		
		/// FIRST PACKET
		
		/// start bit
		#(5*(`BIT_LEN+1)) rx = 1'b0;
		
		/// data bits
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+4)  rx = 1'b0;
		#(`BIT_LEN-3)  rx = 1'b0;
		#(`BIT_LEN+3)  rx = 1'b1;
		#(`BIT_LEN+1)  rx = 1'b1;
		#(`BIT_LEN-2)  rx = 1'b0;
		#(`BIT_LEN+2)  rx = 1'b1;
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
		
		/// stop bit
		#(`BIT_LEN+2)  rx = 1'b1;
		
		/// END OF THIRD PACKET

		/// FOURTH PACKET
		
		/// start bit
		#(5*(`BIT_LEN+1)) rx = 1'b0;
		
		/// data bits
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+4)  rx = 1'b0;
		#(`BIT_LEN-3)  rx = 1'b0;
		#(`BIT_LEN+3)  rx = 1'b1;
		#(`BIT_LEN+1)  rx = 1'b1;
		#(`BIT_LEN-2)  rx = 1'b0;
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+1)  rx = 1'b0;
		
		/// stop bit
		#(`BIT_LEN-2)  rx = 1'b1;
		
		/// END OF FOURTH PACKET
		
		/// FIFTH PACKET
		
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
		
		/// stop bit
		#(`BIT_LEN+1)  rx = 1'b1;
		
		/// END OF FIFTH PACKET
		
		/// SIXTH PACKET
		
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
		
		/// stop bit
		#(`BIT_LEN+2)  rx = 1'b1;
		
		/// END OF SIXTH PACKET

		/// SEVENTH PACKET
		
		/// start bit
		#(5*(`BIT_LEN+1)) rx = 1'b0;
		
		/// data bits
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+4)  rx = 1'b0;
		#(`BIT_LEN-3)  rx = 1'b0;
		#(`BIT_LEN+3)  rx = 1'b1;
		#(`BIT_LEN+1)  rx = 1'b1;
		#(`BIT_LEN-2)  rx = 1'b0;
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+1)  rx = 1'b0;
		
		/// stop bit
		#(`BIT_LEN-2)  rx = 1'b1;
		
		/// END OF SEVENTH PACKET

		/// EIGHTH PACKET
		
		/// start bit
		#(15*(`BIT_LEN+1)) rx = 1'b0;
		
		/// data bits
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+4)  rx = 1'b0;
		#(`BIT_LEN-3)  rx = 1'b0;
		#(`BIT_LEN+3)  rx = 1'b1;
		#(`BIT_LEN+1)  rx = 1'b1;
		#(`BIT_LEN-2)  rx = 1'b0;
		#(`BIT_LEN+2)  rx = 1'b1;
		#(`BIT_LEN+1)  rx = 1'b0;
		
		/// stop bit
		#(`BIT_LEN-2)  rx = 1'b1;
		
		/// END OF EIGHTH PACKET
		
	end

	top DUT(.rx(rx),.clk(clk),.rst(rst),.data(data));
	
	/*
    wire hs,vs;
    wire [2:0]RED,GREEN;
    wire [1:0]BLUE;

	initial begin
        rst = 1'b0;
        #25 rst = ~rst;
        #25 rst = ~rst;
    end

	wire vga_clk;
    clk_divider #(.factor('d4)) clkdiv(.clk(clk),.rst(rst),.dclk(vga_clk));

	vga_top #(.h_res(16),.v_res(9),.h_t_fp(2),.h_t_pw(3),.h_t_bp(1),.v_t_fp(5),.v_t_pw(2),.v_t_bp(7))
        vgat(.clk(vga_clk),.rst(rst),.hs(hs),.vs(vs),.RED(RED),.GREEN(GREEN),.BLUE(BLUE));	*/
	
endmodule