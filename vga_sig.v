`timescale 1ns/10ps

module vga_sig(
    input clk,rst,
    output hs,vs,active,
    output [9:0]x,y
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

    // active = 1(active) while h_count is between h_t_fp + h_t_pw + h_t_bp and line, and v_count is between 0 and v_res
    assign active = (h_count >= h_t_fp + h_t_pw + h_t_bp) & (h_count < line) & (v_count >= 0) & (v_count < v_res);

    assign x = (active) ? h_count - h_t_fp - h_t_pw - h_t_bp : -1; // x position
    assign y = (active) ? v_count : -1; // y position

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            h_count <= -1;
            v_count <= 0;
        end
        else
        begin
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