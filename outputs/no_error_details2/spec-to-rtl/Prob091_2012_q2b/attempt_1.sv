module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    // State assignment:
    // A: 000001 (y[0])
    // B: 000010 (y[1])
    // C: 000100 (y[2])
    // D: 001000 (y[3])
    // E: 010000 (y[4])
    // F: 100000 (y[5])

    // State transitions:
    // A --1--> B, A --0--> A
    // B --1--> C, B --0--> D
    // C --1--> E, C --0--> D
    // D --1--> F, D --0--> A
    // E --1--> E, E --0--> D
    // F --1--> C, F --0--> D

    // Next State Logic:
    // next_A = (A & !w) | (D & !w)
    // next_B = (A & w)
    // next_C = (B & w) | (F & w)
    // next_D = (B & !w) | (C & !w) | (E & !w) | (F & !w)
    // next_E = (C & w) | (E & w)
    // next_F = (D & w)

    // Y1 is the input of state flip-flop y[1] (which is next_B)
    // Y3 is the input of state flip-flop y[3] (which is next_D)

    always @(*) begin
        // Y1 (next_B) = y[0] & w
        // Y3 (next_D) = (y[1] & !w) | (y[2] & !w) | (y[4] & !w) | (y[5] & !w)
    end

    assign Y1 = y[0] & w;
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);

endmodule
