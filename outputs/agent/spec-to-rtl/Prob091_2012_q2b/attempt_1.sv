module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    // State definitions
    // A: y[0], B: y[1], C: y[2], D: y[3], E: y[4], F: y[5]
    // Transitions based on w (input):
    // A --w=1--> B, A --w=0--> A
    // B --w=1--> C, B --w=0--> D
    // C --w=1--> E, C --w=0--> D
    // D --w=1--> F, D --w=0--> A
    // E --w=1--> E, E --w=0--> D
    // F --w=1--> C, F --w=0--> D

    // Next state logic:
    // Y[0] = (~w & y[0]) | (~w & y[3])
    // Y[1] = (w & y[0])
    // Y[2] = (w & y[1]) | (w & y[5])
    // Y[3] = (~w & y[1]) | (~w & y[2]) | (~w & y[4]) | (~w & y[5])
    // Y[4] = (w & y[2]) | (w & y[4])
    // Y[5] = (w & y[3])

    // We only need Y1 and Y3
    assign Y1 = (w & y[0]);
    assign Y3 = (~w & y[1]) | (~w & y[2]) | (~w & y[4]) | (~w & y[5]);

endmodule
