`timescale 1ns/10ps

module vga_top(
    input clk,rst,
    input [127:0]data,
    output o_hs,o_vs,
    output [2:0]RED,GREEN,
    output [1:0]BLUE
);

    wire active;
    wire [9:0]x,y;
    vga_sig VGAS(.clk(clk),.rst(rst),.hs(o_hs),.vs(o_vs),.active(active),.x(x),.y(y));

    reg [9:0]top[0:15];
    reg [9:0]bot[0:15];
    reg [9:0]lef[0:15];
    reg [9:0]rig[0:15];
    reg [0:15]r;

    reg [127:0]data_aux;
    integer i;

    always @(*)
    begin
        for(i=0;i<16;i=i+1)
        begin
            lef[i] = (i * 80 + 1) % 640;
            rig[i] = ((i + 1) * 80) % 640 - 1;
            if(i<8) // top of the screen, left channel, ms64b of data
            begin
                top[i] = 240 - (data_aux[127:120]*240)/255;
                data_aux = data_aux << 8;
                bot[i] = 239;
            end
            else // bottom of the screen, right channel, ls64b of data
            begin
                top[i] = 479 - (data_aux[127:120]*240)/255;
                data_aux = data_aux << 8;
                bot[i] = 479;
            end
            
            r[i] = (x >= lef[i] & x < rig[i]) & (y >= top[i] & y < bot[i]);
        end
        data_aux = data;
    end

    assign RED = {3{(r[0]|r[1]|r[2]|r[3]|r[4]|r[5]|r[6]|r[7]|r[8]|r[9]|r[10]|r[11]|r[12]|r[13]|r[14]|r[15]) & ((y >= 0 & y < 120) | (y >= 240 & y < 360))}};
    assign GREEN = {3{(r[0]|r[1]|r[2]|r[3]|r[4]|r[5]|r[6]|r[7]|r[8]|r[9]|r[10]|r[11]|r[12]|r[13]|r[14]|r[15]) & ((y >= 280 & y < 479) | (y >= 40 & y < 240))}};
    assign BLUE = 2'b00;

endmodule