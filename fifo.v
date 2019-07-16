`timescale 1ns/10ps

module fifo(
    input clk,rst,
    input [7:0]data_in,
    output reg [63:0]data_out
);

    always @(posedge clk or posedge rst)
    begin
        if(rst)
            data_out <= 64'd0;
        else
            data_out <= {data_in,data_out[63:8]};
    end

endmodule