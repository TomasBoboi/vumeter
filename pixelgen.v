`timescale 1ns/10ps

module pixelgen(
    input clk,rst,
    input state,
    input [9:0]hc,
    input [8:0]vc,
    output reg [2:0]RED,GREEN,
    output reg [1:0]BLUE
);

    reg [2:0]RED_nxt,GREEN_nxt;
    reg [1:0]BLUE_nxt;

    always @(*)
    begin
        if(state == 3)
        begin
            if(hc >= 0 && hc < 160)
            begin
                RED_nxt = 'b000;
                GREEN_nxt = 'b000;
                BLUE_nxt = 'b11;
            end
            else if(hc >= 160 && hc < 320)
            begin
                RED_nxt = 'b111;
                GREEN_nxt = 'b111;
                BLUE_nxt = 'b00;
            end
            else
            begin
                RED_nxt = 'b111;
                GREEN_nxt = 'b000;
                BLUE_nxt = 'b00;
            end
        end
        else
        begin
            RED_nxt = 'd0;
            GREEN_nxt = 'd0;
            BLUE_nxt = 'd0;
        end
    end

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            RED <= 'd0;
            GREEN <= 'd0;
            BLUE <= 'd0;
        end
        else
        begin
            RED <= RED_nxt;
            GREEN <= GREEN_nxt;
            BLUE <= BLUE_nxt;
        end
    end

endmodule