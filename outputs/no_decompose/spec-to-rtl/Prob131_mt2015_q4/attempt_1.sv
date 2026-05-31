module ModuleA(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module ModuleB(input x, input y, output z);
    // Truth table analysis:
    // x y | z
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 1
    // This is XNOR: z = ~(x ^ y)
    assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
    logic a1_out, b1_out, a2_out, b2_out;
    logic or_out, and_out;

    ModuleA m_a1(x, y, a1_out);
    ModuleB m_b1(x, y, b1_out);
    
    ModuleA m_a2(x, y, a2_out);
    ModuleB m_b2(x, y, b2_out);

    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;
endmodule
