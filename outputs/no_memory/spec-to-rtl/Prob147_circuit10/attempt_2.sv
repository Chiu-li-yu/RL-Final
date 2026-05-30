module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    logic next_state;

    // Based on the truth table analysis:
    // state  a  b | next_state  q
    // 0      0  0 | 0           0
    // 0      0  1 | 0           1
    // 0      1  0 | 0           1
    // 0      1  1 | 1           0
    // 1      0  0 | 0           1
    // 1      0  1 | 1           0
    // 1      1  0 | 1           0
    // 1      1  1 | 1           1

    // k-map for next_state:
    // next_state = (a & b) | (state & b) | (state & a)
    // next_state = (a & b) | (state & (a | b))

    // k-map for q:
    // q = (~state & ((~a & b) | (a & ~b))) | (state & ((~a & ~b) | (a & b)))
    // This is equivalent to q = state ^ ~(a ^ b)  or q = state ^ (a ~^ b) 
    // Wait, let's verify:
    // q = (a ^ b) ^ ~state  => q = !(a ^ b ^ state)

    always @(*) begin
        next_state = (a & b) | (state & a) | (state & b);
        q = ~(a ^ b ^ state);
    end

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule