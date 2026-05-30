module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // One-hot assignment:
    // A: y[0] = 000001
    // B: y[1] = 000010
    // C: y[2] = 000100
    // D: y[3] = 001000
    // E: y[4] = 010000
    // F: y[5] = 100000

    // State transitions:
    // A --0--> B (y[0] & ~w)
    // A --1--> A (y[0] & w)
    // B --0--> C (y[1] & ~w)
    // B --1--> D (y[1] & w)
    // C --0--> E (y[2] & ~w)
    // C --1--> D (y[2] & w)
    // D --0--> F (y[3] & ~w)
    // D --1--> A (y[3] & w)
    // E --0--> E (y[4] & ~w)
    // E --1--> D (y[4] & w)
    // F --0--> C (y[5] & ~w)
    // F --1--> D (y[5] & w)

    // Next State Logic:
    // Next A (y[0]_next) = (y[0] & w) | (y[3] & w)
    // Next B (y[1]_next) = (y[0] & ~w)
    // Next C (y[2]_next) = (y[1] & ~w) | (y[5] & ~w)
    // Next D (y[3]_next) = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w)
    // Next E (y[4]_next) = (y[2] & ~w) | (y[4] & ~w)
    // Next F (y[5]_next) = (y[3] & ~w)

    // Output Y1 corresponds to next state B
    // Output Y3 corresponds to next state D

    always @(*) begin
        // Y1 is the next state of B, which is 1 only when from A and w=0
        // Y1 = y[0] & ~w
    end

    assign Y1 = y[0] & ~w;
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule
