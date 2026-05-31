module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    // Let's re-analyze the waveforms carefully:
    // time 15ns: clk=1, a=0, b=0, state=0 -> q=0
    // time 45ns: clk=1, a=0, b=1, state=0 -> q=1
    // time 65ns: clk=1, a=1, b=1, state=0 -> q=0
    // time 75ns: clk=1, a=0, b=0, state=1 -> q=1
    // time 85ns: clk=1, a=1, b=1, state=0 -> q=0
    // time 95ns: clk=1, a=1, b=1, state=1 -> q=1
    // time 115ns: clk=1, a=1, b=0, state=1 -> q=0
    // time 125ns: clk=1, a=0, b=1, state=1 -> q=0
    // time 135ns: clk=1, a=0, b=0, state=1 -> q=1
    // time 145ns: clk=1, a=0, b=0, state=0 -> q=0

    // state transition:
    // (a=1, b=1, state=0) -> state=1 (at 65-75ns, 95ns)
    // (a=1, b=0, state=1) -> state=0 (at 115-125ns)
    // (a=0, b=0, state=1) -> state=0 (at 135-145ns)

    // next_state = (a & b & ~state) | (state & ~(a & ~b) & ~(~a & b))  ... this is messy.
    // Try: next_state = (a & b) | (state & ~(a ^ b))

    logic next_state;

    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        next_state = (a & b & ~state) | (state & ~(a ^ b));
        q = a ^ b ^ state;
    end

endmodule
