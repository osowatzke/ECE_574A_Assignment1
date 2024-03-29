`timescale 1ns / 1ns

module circuit1(a, b, c, z, x, clk, rst);

        input  clk, rst;
        input  [ 7:0] a, b, c;

        output [ 7:0] z;
        output [15:0] x;

        wire   g;
        wire   [ 7:0] d, e, zwire;
        wire   [15:0] f;
        wire   [15:0] xwire;
        wire   [15:0] a_16, c_16, d_16;

        assign a_16 = {{8{1'b0}}, a};
        assign c_16 = {{8{1'b0}}, c};
        assign d_16 = {{8{1'b0}}, d};

        ADD    #(.DATAWIDTH( 8)) ADD_1(a, b, d);                    // d = a + b
        ADD    #(.DATAWIDTH( 8)) ADD_2(a, c, e);                    // e = a + c
        
        // Using modified comparator and lt output to be
        // consistent with comments in sample behavioral netlist.
        COMP   #(.DATAWIDTH( 8)) COMP_1(d, e, , g, );               // g = d > e
        MUX2x1 #(.DATAWIDTH( 8)) MUX2x1_1(e, d, g, zwire);          // z = g ? d : e
        
        // Adding register for output z even though there was
        // no explicit line in the behavioral netlist. This
        // matches assignment description, which says that each
        // output is implicitly associated with a register (REG)
        // component. Also, confirmed this with Dr. Tosi.
        REG    #(.DATAWIDTH( 8)) REG_1(z, zwire, clk, rst);
        
        // Making multiplier width equal to the maximum width
        // of the inputs and outputs. This is different from
        // the assignment description, but should provide
        // results consistent with the verilog implementation
        // of f = a * c. Discussed this with Dr. Tosi and
        // he aggreed with our implementation.
        MUL    #(.DATAWIDTH(16)) MUL_1(a_16, c_16, f);              // f = a * c
        SUB    #(.DATAWIDTH(16)) SUB_1(f, d_16, xwire);             // xwire = f - d
        REG    #(.DATAWIDTH(16)) REG_2(x, xwire, clk, rst);         // x = xwire

endmodule
