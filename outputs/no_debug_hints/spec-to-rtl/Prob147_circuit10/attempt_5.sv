module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    // Let's use K-map or truth table:
    // a b s | q | next_s
    // 0 0 0 | 0 | 0
    // 0 1 0 | 1 | 0
    // 1 0 0 | 1 | 0
    // 1 1 0 | 0 | 1
    // 0 0 1 | 1 | 1
    // 0 1 1 | 0 | 1
    // 1 0 1 | 0 | 0
    // 1 1 1 | 1 | 1

    // q = a ^ b ^ state
    // next_s = (a & b & ~s) | (~a & ~b & s) | (~a & b & s) | (a & b & s)
    // next_s = (a & b) | (~a & s) | (~b & s) ... let's check
    // next_s = (a & b) | (s & (~a | ~b)) = (a & b) | (s & ~(a & b))

    logic next_state;

    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        next_state = (a & b) | (state & ~(a & b));
        q = a ^ b ^ state;
    end

endmodule
