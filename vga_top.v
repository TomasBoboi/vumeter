`timescale 1ns/10ps

`define S_HFP   0 // horizontal front porch
`define S_HPW   1 // horizontal sync
`define S_HBP   2 // horizontal back porch
`define S_DRAWL 3 // draw active line

`define S_DRAWF 4 // draw active frame
`define S_VFP   5 // vertical front porch
`define S_VPW   6 // vertical sync
`define S_VBP   7 // vertical back porch

module vga_top(
    input clk,rst,
    output hs,vs,
    output reg [2:0]RED,GREEN,
    output reg [1:0]BLUE
);

    // default mode: 640x480@60
    parameter [9:0]h_res = 'd640;  // horizontal resolution - pixels
    parameter [9:0]v_res = 'd480;  // vertical resolution   - pixels
    
    parameter [4:0]h_t_fp = 'd16; // horizontal front porch - clocks
    parameter [6:0]h_t_pw = 'd96; // horizontal pulse width - clocks
    parameter [5:0]h_t_bp = 'd48; // horizontal back porch  - clocks
    // one line = 800 clocks (for 640x480@60)

    parameter [3:0]v_t_fp = 'd10; // vertical front porch   - lines
    parameter [2:0]v_t_pw = 'd2;  // vertical pulse width   - lines
    parameter [5:0]v_t_bp = 'd33; // vertical back porch    - lines
    // one frame = 525 lines = 420.000 clocks (for 640x480@60)

    localparam line = h_res + h_t_fp + h_t_pw + h_t_bp;
    localparam frame = v_res + v_t_fp + v_t_pw + v_t_bp;

    reg [9:0]h_count,v_count;

    assign hs = ~((h_count >= h_t_fp) & (h_count < h_t_fp + h_t_pw));                 // hs = 0(active) while h_count is between h_t_fp and h_t_fp + h_t_pw
    assign vs = ~((v_count >= v_res + v_t_fp) & (v_count < v_res + v_t_fp + v_t_pw)); // vs = 0(active) while v_count is between v_t_fp and v_t_fp + v_t_pw

    reg [2:0]h_state_ff,h_state_nxt,v_state_ff,v_state_nxt;

    always @(*)
    begin
        case(h_state_ff)
            `S_HFP:
            begin
                RED = 'd0;
                GREEN = 'd0;
                BLUE = 'd0;
                if(hs)
                    h_state_nxt = `S_HFP;
                else
                    h_state_nxt = `S_HPW;
            end
            `S_HPW:
            begin
                RED = 'd0;
                GREEN = 'd0;
                BLUE = 'd0;
                if(~hs)
                    h_state_nxt = `S_HPW;
                else
                    h_state_nxt = `S_HBP;
            end
            `S_HBP:
            begin
                RED = 'd0;
                GREEN = 'd0;
                BLUE = 'd0;
                if(h_count >= h_t_fp + h_t_pw && h_count < h_t_fp + h_t_pw + h_t_bp) // if we are in the back porch region
                    h_state_nxt = `S_HBP;
                else
                    h_state_nxt = `S_DRAWL;
            end
            `S_DRAWL:
            begin
                if(h_count == line - 1)
                    h_state_nxt = `S_HFP;
                else
                    h_state_nxt = `S_DRAWL;
                
                // ACTUAL DRAWING
                /*
                if(v_count >= 0 && v_count < 160)
                begin
                    RED = 'd111;
                    GREEN = 'd000;
                    BLUE = 'd00;
                end
                else if(v_count >= 160 && v_count < 320)
                begin
                    RED = 'd111;
                    GREEN = 'd111;
                    BLUE = 'd11;
                end
                else if(v_count >= 320 && v_count < 480)
                begin
                    RED = 'd000;
                    GREEN = 'd111;
                    BLUE = 'd00;
                end
                else
                begin
                    RED = 'd0;
                    GREEN = 'd0;
                    BLUE = 'd0;
                end
                */

                if(v_state_ff == `S_DRAWF)
                begin
                    RED = {h_count[2],h_count[1],h_count[0]};
                    GREEN = {v_count[2],v_count[1],v_count[0]};
                    BLUE = {h_count[3],v_count[3]};
                end
                else
                begin
                    RED = 'd0;
                    GREEN = 'd0;
                    BLUE = 'd0;
                end
            end
        endcase

        case(v_state_ff)
            `S_VFP:
            begin
                if(vs)
                    v_state_nxt = `S_VFP;
                else
                    v_state_nxt = `S_VPW;
            end
            `S_VPW:
            begin
                if(~vs)
                    v_state_nxt = `S_VPW;
                else
                    v_state_nxt = `S_VBP;
            end
            `S_VBP:
            begin
                if(v_count >= v_res + v_t_fp + v_t_pw && v_count < v_res + v_t_fp + v_t_pw + v_t_bp) // if we are in the back porch region
                    v_state_nxt = `S_VBP;
                else
                    v_state_nxt = `S_DRAWF;
            end
            `S_DRAWF:
            begin
                if(v_count == v_res - 1)
                    v_state_nxt = `S_VFP;
                else
                    v_state_nxt = `S_DRAWF;
            end
        endcase
    end

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            h_state_ff <= `S_HFP;
            v_state_ff <= `S_DRAWF;

            h_count <= -1;
            v_count <= 0;
        end
        else
        begin
            h_state_ff <= h_state_nxt;
            v_state_ff <= v_state_nxt;

            if(h_count == line - 1)
            begin
                h_count <= 0;
                v_count <= v_count + 1;
            end
            else
            begin
                h_count <= h_count + 1;
            end

            if(v_count == frame)
            begin
                v_count <= 0;
            end
        end

    end

endmodule