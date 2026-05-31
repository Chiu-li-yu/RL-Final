module TopModule(
    input clock,
    input a,
    output p,
    output q
);
    logic p_i, q_i;
    
    // Analyzing trace:
    // 90ns:  clk=1, a=1 -> p=1, q=0
    // 100ns: clk=1, a=1 -> p=1, q=0
    // 115ns: clk=0, a=0 -> p=1, q=1
    // 120ns: clk=0, a=1 -> p=1, q=1
    // 145ns: clk=1, a=0 -> p=0, q=1
    // 165ns: clk=1, a=1 -> p=1, q=1
    
    // It looks like:
    // p = (clock & a) | (~clock & q)
    // q_next = (clock & q) | (~clock & a) -- no, that's not it.
    
    // Let's try:
    // q latches 'a' when clock=0
    // p is 'a' when clock=1, else 'q'
    
    logic q_reg;
    always @(negedge clock) begin
        q_reg <= a;
    end
    
    assign p = (clock) ? a : q_reg;
    assign q = q_reg;

endmodule