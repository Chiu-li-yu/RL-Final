module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // State encoding:
    // A: y[0]=1 (000001)
    // B: y[1]=1 (000010)
    // C: y[2]=1 (000100)
    // D: y[3]=1 (001000)
    // E: y[4]=1 (010000)
    // F: y[5]=1 (100000)

    // Transitions:
    // A --w=1--> B, A --w=0--> A
    // B --w=1--> C, B --w=0--> D
    // C --w=1--> E, C --w=0--> D
    // D --w=1--> F, D --w=0--> A
    // E --w=1--> E, E --w=0--> D
    // F --w=1--> C, F --w=0--> D

    // Y1 (next state for B) is 1 if (A AND w=1)
    assign Y1 = (y[0] && w);

    // Y3 (next state for D) is 1 if (B AND w=0) OR (C AND w=0) OR (E AND w=0) OR (F AND w=0)
    assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[5] && !w);

endmodule