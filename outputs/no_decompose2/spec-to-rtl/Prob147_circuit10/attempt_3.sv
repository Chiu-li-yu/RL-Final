module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);
    // Re-check waveform:
    // time 15ns (first posedge): a=0, b=0, prev_state=x, new_state=0
    // Actually, looking at the waveform:
    // When clk=1 (pos edge), state changes to the next value.
    // 15ns: clk=1, a=0, b=0, state=0, q=0. Next state for 25ns?
    // 25ns: clk=1, a=0, b=0, state=0, q=0.
    // 45ns: clk=1, a=0, b=1, state=0, q=1.
    // 65ns: clk=1, a=1, b=1, state=0, q=0.
    // 75ns: clk=1, a=0, b=0, state=1, q=1. (State became 1)
    // 85ns: clk=1, a=1, b=1, state=0, q=0. (State became 0)
    // 95ns: clk=1, a=1, b=1, state=1, q=1. (State became 1)

    // Let's try:
    // state(t+1) = state(t) ^ (a & b)
    // q = state ^ a ^ b

    logic next_state;

    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        next_state = state ^ (a & b);
        q = state ^ a ^ b;
    end

endmodule
