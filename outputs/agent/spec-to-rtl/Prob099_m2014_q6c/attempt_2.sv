module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot mapping: 
    // y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    
    // State B (y[1]) next state transition:
    // A --0--> B
    // Y1 = y[0] & (~w)

    // State D (y[3]) next state transition:
    // B --1--> D
    // C --1--> D
    // E --1--> D
    // F --1--> D
    // Y3 = w & (y[1] | y[2] | y[4] | y[5])

    assign Y1 = y[0] & (~w);
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule
