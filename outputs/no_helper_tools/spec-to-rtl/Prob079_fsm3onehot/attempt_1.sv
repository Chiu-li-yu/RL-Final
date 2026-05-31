module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot encoding: A=0001, B=0010, C=0100, D=1000
    logic A, B, C, D;
    assign {D, C, B, A} = state;

    // State transition logic
    // A (0001): in=0 -> A (0001), in=1 -> B (0010)
    // B (0010): in=0 -> C (0100), in=1 -> B (0010)
    // C (0100): in=0 -> A (0001), in=1 -> D (1000)
    // D (1000): in=0 -> C (0100), in=1 -> B (0010)

    logic next_A, next_B, next_C, next_D;

    always @(*) begin
        next_A = (~in & A) | (~in & C);
        next_B = (in & A) | (in & B) | (in & D);
        next_C = (~in & B) | (~in & D);
        next_D = (in & C);
    end

    assign next_state = {next_D, next_C, next_B, next_A};

    // Output logic
    // Output 1 only in state D
    assign out = D;

endmodule
