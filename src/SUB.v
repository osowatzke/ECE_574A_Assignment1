`timescale 1ns/1ns

module SUB(a,b,diff);

    parameter DATAWIDTH = 32;
    input signed [DATAWIDTH-1:0] a;
    input signed [DATAWIDTH-1:0] b;

    output reg signed [DATAWIDTH-1:0] diff;

    always @(a,b) begin
        diff <= a-b;
    end
endmodule