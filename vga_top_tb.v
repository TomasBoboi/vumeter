`timescale 1ns/10ps

module vga_top_tb;

    reg clk,rst;
    wire hs,vs;
    wire [2:0]RED,GREEN;
    wire [1:0]BLUE;

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1'b0;
        #25 rst = ~rst;
        #25 rst = ~rst;
    end

    wire vga_clk;
    clk_divider #(.factor('d4)) clkdiv(.clk(clk),.rst(rst),.dclk(vga_clk));

    vga_top #(.h_res(16),.v_res(9),.h_t_fp(2),.h_t_pw(3),.h_t_bp(1),.v_t_fp(5),.v_t_pw(2),.v_t_bp(7))
        vgat(.clk(vga_clk),.rst(rst),.hs(hs),.vs(vs),.RED(RED),.GREEN(GREEN),.BLUE(BLUE));

endmodule