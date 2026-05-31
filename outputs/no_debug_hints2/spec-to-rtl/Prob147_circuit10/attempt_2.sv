module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    // Re-evaluating the logic based on provided truth table
    // state  a  b | q | state_next
    // 0      0  0 | 0 | 0
    // 0      0  1 | 1 | 0
    // 0      1  0 | 1 | 0
    // 0      1  1 | 0 | 0
    // 1      0  0 | 1 | 1
    // 1      0  1 | 0 | 1
    // 1      1  0 | 0 | 1
    // 1      1  1 | 1 | 1

    // Logic:
    // q = (a ^ b ^ state) ^ 1  => (~a & ~b & state) | (~a & b & ~state) | (a & ~b & ~state) | (a & b & state)
    // Actually: q = ~(a ^ b ^ state)
    // next_state = state

    logic next_state;

    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        next_state = state;
        q = ~(a ^ b ^ state);
    end

endmodule
