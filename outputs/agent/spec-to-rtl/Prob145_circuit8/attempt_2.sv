module TopModule (
    input clock,
    input a,
    output logic p,
    output logic q
);

    // Let's look at the data again:
    // 85ns: a=1, p=0, q=0
    // 90ns: a=1, p=1, q=0
    // 95ns: a=0, p=0, q=0
    // 100ns: a=1, p=1, q=0
    // 105ns: a=0, p=0, q=0
    // 110ns: a=1, p=1, q=0
    // 115ns: a=0, p=1, q=1
    // 120ns: a=1, p=1, q=1
    // It looks like:
    // p = a | (something about previous q)
    // q = (something)

    // Re-evaluating:
    // p(t) = a(t) ^ q(t)
    // q(t+1) = a(t)
    
    // Let's test this:
    // 85ns (clk rising): a=1, q=0 -> p=1^0=1 (Mismatch, table says p=0)
    
    // Maybe p is registered:
    // p(t) = a(t-1)
    // q(t) = a(t) | q(t-1) ... no.

    // Let's look at the state machine.
    // It looks like a classic state machine problem.
    // Let's try:
    // p = a ^ q
    // q = (q & !a) | (p & a) ??
    
    logic q_reg;
    always_ff @(posedge clock) begin
        q_reg <= a;
    end
    
    assign p = a ^ q_reg;
    assign q = q_reg;

endmodule
