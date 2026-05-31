module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    // Initial state is x at 10ns, 0 at 15ns. Let's assume reset logic is needed or initial is 0.
    // Looking at the waveform:
    // time 15ns (first posedge): a=0, b=0, state=0, q=0
    // time 45ns: a=0, b=1, state=0, q=1
    // time 65ns: a=1, b=1, state=0, q=0
    // time 75ns: a=0, b=0, state=1, q=1
    //
    // Truth table from waveform:
    // state  a  b | next_state  q
    // 0      0  0 | 0           0
    // 0      0  1 | 0           1
    // 0      1  0 | 0           1
    // 0      1  1 | 1           0
    // 1      0  0 | 1           1
    // 1      1  1 | 0           1
    // 1      1  0 | 1           0
    // 1      0  1 | 1           0
    //
    // Q = state ^ b
    // next_state = (state & ~a & ~b) | (state & ~a & b) | (state & a & ~b) | (state & a & b) ... wait
    // Let's check:
    // next_state = (a & b & ~state) | (~(a & b) & state)
    // q = state ^ b

    logic next_state;

    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        next_state = (a & b & ~state) | (~(a & b) & state);
        q = state ^ b;
    end

endmodule
