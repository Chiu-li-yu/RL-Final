module ModuleA(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

module ModuleB(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

module TopModule(input x, input y, output z);
    logic a1_out, a2_out, b1_out, b2_out;
    logic o1, o2;

    ModuleA m_a1(x, y, a1_out);
    ModuleA m_a2(x, y, a2_out);
    ModuleB m_b1(x, y, b1_out);
    ModuleB m_b2(x, y, b2_out);

    always @(*) begin
        o1 = a1_out | b1_out;
        o2 = a2_out & b2_out;
        z = o1 ^ o2;
    end
endmodule