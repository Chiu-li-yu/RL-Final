module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot mapping
    // A: y[0], B: y[1], C: y[2], D: y[3], E: y[4], F: y[5]
    
    // Y1 (Next State B):
    // From transitions: A --0--> B
    // Therefore, B_next = A & (~w)
    assign Y1 = y[0] & (~w);

    // Y3 (Next State D):
    // From transitions: 
    // B --1--> D
    // C --1--> D
    // E --1--> D
    // F --1--> D
    // Therefore, D_next = (B | C | E | F) & w
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule
