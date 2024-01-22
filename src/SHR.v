`timescale 1ns/1ns

module SHR(a,sh_amt,d);

    parameter DATAWIDTH = 32;
    input signed [DATAWIDTH-1:0] a;
    input sh_amt;

    output reg signed [DATAWIDTH-1:0] d;

    always @(a,b) begin
        d <= a >> sh_amt;
    end
endmodule