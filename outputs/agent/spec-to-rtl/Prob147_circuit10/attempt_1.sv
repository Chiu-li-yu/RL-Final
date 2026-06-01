module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    logic next_state;

    // Based on the observed waveform:
    // (state, a, b) -> (next_state, q)
    // (0, 0, 0) -> (0, 0)
    // (0, 0, 1) -> (0, 1)
    // (0, 1, 0) -> (0, 1)
    // (0, 1, 1) -> (1, 0)
    // (1, 0, 0) -> (0, 1)
    // (1, 0, 1) -> (1, 0)
    // (1, 1, 0) -> (1, 0)
    // (1, 1, 1) -> (1, 1)

    // Truth Table for next_state:
    // s  a  b  | ns
    // 0  0  0  | 0
    // 0  0  1  | 0
    // 0  1  0  | 0
    // 0  1  1  | 1
    // 1  0  0  | 0
    // 1  0  1  | 1
    // 1  1  0  | 1
    // 1  1  1  | 1
    // next_state = (s & a) | (s & b) | (a & b)  (Majority function of s, a, b)

    // Truth Table for q:
    // s  a  b  | q
    // 0  0  0  | 0
    // 0  0  1  | 1
    // 0  1  0  | 1
    // 0  1  1  | 0
    // 1  0  0  | 1
    // 1  0  1  | 0
    // 1  1  0  | 0
    // 1  1  1  | 1
    // q = s ^ a ^ b

    always @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        next_state = (state & a) | (state & b) | (a & b);
        q = state ^ a ^ b;
    end

endmodule
