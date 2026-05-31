module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot state assignment:
    // A: y[0] = 000001
    // B: y[1] = 000010
    // C: y[2] = 000100
    // D: y[3] = 001000
    // E: y[4] = 010000
    // F: y[5] = 100000

    // Transitions (from input w):
    // A(y0) --0--> B(y1),  --1--> A(y0)
    // B(y1) --0--> C(y2),  --1--> D(y3)
    // C(y2) --0--> E(y4),  --1--> D(y3)
    // D(y3) --0--> F(y5),  --1--> A(y0)
    // E(y4) --0--> E(y4),  --1--> D(y3)
    // F(y5) --0--> C(y2),  --1--> D(y3)

    // Y1 (Next state B):
    // Active when transition to B occurs: A -> B (w=0)
    // Y1 = y[0] & (~w)

    // Y3 (Next state D):
    // Active when transition to D occurs: B -> D (w=1), C -> D (w=1), E -> D (w=1), F -> D (w=1)
    // Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w)
    // Y3 = w & (y[1] | y[2] | y[4] | y[5])

    always @(*) begin
        // Y1 is 1 when in state A and w is 0
        assign Y1 = y[0] & (~w);
        
        // Y3 is 1 when in state B, C, E, F and w is 1
        assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule