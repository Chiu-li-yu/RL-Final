module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot state assignment:
    // A: y[0]=1, B: y[1]=1, C: y[2]=1, D: y[3]=1, E: y[4]=1, F: y[5]=1

    // State Transitions to B (Y1):
    // A (y[0]) --w=1--> B
    // Therefore, Y1 = y[0] & w
    assign Y1 = y[0] & w;

    // State Transitions to D (Y3):
    // B (y[1]) --w=0--> D
    // C (y[2]) --w=0--> D
    // E (y[4]) --w=0--> D
    // F (y[5]) --w=0--> D
    // Therefore, Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule
