module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    // State assignment:
    // A: 6'b000001
    // B: 6'b000010
    // C: 6'b000100
    // D: 6'b001000
    // E: 6'b010000
    // F: 6'b100000

    // Next state logic:
    // A(000001) --1--> B(000010)
    // A(000001) --0--> A(000001)
    // B(000010) --1--> C(000100)
    // B(000010) --0--> D(001000)
    // C(000100) --1--> E(010000)
    // C(000100) --0--> D(001000)
    // D(001000) --1--> F(100000)
    // D(001000) --0--> A(000001)
    // E(010000) --1--> E(010000)
    // E(010000) --0--> D(001000)
    // F(100000) --1--> C(000100)
    // F(100000) --0--> D(001000)

    // Y1 is the input of state flip-flop y[1] (State B)
    // Next state is B when: (A=1 and w=1)
    assign Y1 = (y[0] && w);

    // Y3 is the input of state flip-flop y[3] (State D)
    // Next state is D when: (B=1 and w=0) or (C=1 and w=0) or (E=1 and w=0) or (F=1 and w=0)
    assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[5] && !w);

endmodule