module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // One-hot states:
    // A: y[0], B: y[1], C: y[2], D: y[3], E: y[4], F: y[5]
    
    // State transitions:
    // A --0--> B  (y[1] gets signal from y[0] when w=0)
    // A --1--> A
    // B --0--> C
    // B --1--> D
    // C --0--> E
    // C --1--> D
    // D --0--> F
    // D --1--> A
    // E --0--> E
    // E --1--> D
    // F --0--> C
    // F --1--> D

    // Next state logic for state B (y[1]):
    // B is the next state from A if w=0.
    assign Y1 = (~w & y[0]);

    // Next state logic for state D (y[3]):
    // D is the next state from B if w=1
    // D is the next state from C if w=1
    // D is the next state from E if w=1
    // D is the next state from F if w=1
    assign Y3 = (w & y[1]) | (w & y[2]) | (w & y[4]) | (w & y[5]);

endmodule
