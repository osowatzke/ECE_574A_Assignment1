`timescale 1ns/1ns

module DIV_tb();

    parameter DATAWIDTH = 32;
    
    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;
    localparam INIT       = 2'b00;
    localparam A_ONLY     = 2'b01;
    localparam B_ONLY     = 2'b10;
    localparam A_AND_B    = 2'b11;
    
    reg  [DATAWIDTH-1:0] a;
    reg  [DATAWIDTH-1:0] b;
    reg  [DATAWIDTH-1:0] qout_ref;
    wire [DATAWIDTH-1:0] qout_meas;
    
    reg [1:0] state;
    reg valid;
    
    wire clk;
    wire rst;
    wire err;
    
    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);
    
    always @(posedge clk) begin
        if (rst == 1) begin
            a        <= 0;
            b        <= 0;
            qout_ref <= 0;
            valid    <= 0;
            state    <= INIT;
        end
        else begin
            valid   <= 1;
            case (state)
                INIT : begin
                    a        <= 1;
                    b        <= 1;
                    qout_ref <= 1;
                    state    <= A_ONLY;
                end
                A_ONLY : begin
                    a         = $urandom;
                    qout_ref <= a;
                    state    <= B_ONLY;
                end
                B_ONLY : begin
                    b         = $urandom;
                    qout_ref <= a/b;
                    state    <= A_AND_B;
                end
                default : begin
                    a         = $urandom;
                    b         = $urandom;
                    qout_ref <= a/b;
                    state    <= A_AND_B;
                end
            endcase
        end
    end
    
    DIV #(.DATAWIDTH(DATAWIDTH)) DIV_i(a,b,qout_meas);
    error_monitor #(.DATAWIDTH(DATAWIDTH)) error_monitor_i(qout_meas,qout_ref,valid,err,clk,rst);
endmodule