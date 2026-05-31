module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    // Initial state
    initial state = 0;

    // Based on the data:
    // state changes (75ns, 85ns, 95ns, 145ns)
    // 75ns: clk=1, a=0, b=0, prev_state=0 -> state=1
    // 85ns: clk=1, a=1, b=1, prev_state=1 -> state=0
    // 95ns: clk=1, a=1, b=1, prev_state=0 -> state=1
    // 145ns: clk=1, a=0, b=0, prev_state=1 -> state=0
    // Looks like if a == b, state flips?
    // 75ns: a=0, b=0, state 0->1
    // 85ns: a=1, b=1, state 1->0
    // 95ns: a=1, b=1, state 0->1
    // 145ns: a=0, b=0, state 1->0
    // Yes, state <= (a == b) ? ~state : state;
    
    always @(posedge clk) begin
        state <= (a == b) ? ~state : state;
    end

    // q output:
    // 15ns: a=0, b=0, state=0 -> q=0
    // 45ns: a=0, b=1, state=0 -> q=1
    // 65ns: a=1, b=1, state=0 -> q=0
    // 75ns: a=0, b=0, state=1 -> q=1
    // 115ns: a=1, b=0, state=1 -> q=0
    // 125ns: a=0, b=1, state=1 -> q=0
    // 135ns: a=0, b=0, state=1 -> q=1
    // 145ns: a=0, b=0, state=0 -> q=0
    
    // Truth table:
    // a b s | q
    // 0 0 0 | 0
    // 0 1 0 | 1
    // 1 0 0 | 0
    // 1 1 0 | 0
    // 0 0 1 | 1
    // 0 1 1 | 0
    // 1 0 1 | 0
    // 1 1 1 | 0
    
    // Simplified q:
    // q = (~a & b & ~s) | (~a & ~b & s)
    // q = ~a & (b ^ s)

    assign q = ~a & (b ^ state);

endmodule