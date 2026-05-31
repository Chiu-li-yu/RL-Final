module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State Encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // State Transition Logic
    // A: if in=0 -> A, if in=1 -> B
    // B: if in=0 -> C, if in=1 -> B
    // C: if in=0 -> A, if in=1 -> D
    // D: if in=0 -> C, if in=1 -> B

    logic next_A, next_B, next_C, next_D;

    always @(*) begin
        next_A = (state[0] & ~in) | (state[2] & ~in);
        next_B = (state[0] & in) | (state[1] & in) | (state[3] & in);
        next_C = (state[1] & ~in) | (state[3] & ~in);
        next_D = (state[2] & in);
    end

    assign next_state = {next_D, next_C, next_B, next_A};

    // Output Logic
    // Output 1 only when state is D
    assign out = state[3];

endmodule
