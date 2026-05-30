module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot state assignment:
    // A: 000001 (y[0])
    // B: 000010 (y[1])
    // C: 000100 (y[2])
    // D: 001000 (y[3])
    // E: 010000 (y[4])
    // F: 100000 (y[5])

    // State B is y[1], State D is y[3]
    
    // Y1 (Next B) comes from:
    // A --w=1--> B
    // Y1 = y[0] & w
    
    // Y3 (Next D) comes from:
    // B --w=0--> D
    // C --w=0--> D
    // E --w=0--> D
    // F --w=0--> D
    // Y3 = (y[1] | y[2] | y[4] | y[5]) & (~w)

    logic n_Y1;
    logic n_Y3;

    always @(*) begin
        n_Y1 = (y[0] & w);
        n_Y3 = (!w & (y[1] | y[2] | y[4] | y[5]));
    end

    assign Y1 = n_Y1;
    assign Y3 = n_Y3;

endmodule