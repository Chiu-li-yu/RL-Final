module TopModule (
    input logic clock,
    input logic a,
    output logic p,
    output logic q
);
    // q is now correct (q_reg).
    // Now fix p.
    // At 70ns: clock=0, a=0, p=1. My code gives p=0.
    // Oh, the table says p=1 when clock=0 and a=0 (sometimes).
    // Let's re-read:
    // 70ns: clock=0, a=0, p=1, q=0
    // 80ns: clock=0, a=0, p=1, q=0
    // 140ns: clock=0, a=0, p=1, q=1
    
    // So p = (a & clock) | (~clock & (something?))
    // 70ns: clock=0, a=0 -> p=1. 
    // 115ns: clock=0, a=0 -> p=1.
    // 175ns: clock=0, a=1 -> p=0.
    // Looks like p = ~(~clock & a)  => p = clock | ~a
    
    assign p = clock | ~a;
    
    logic q_reg;
    assign q = q_reg;
    
    always_ff @(negedge clock) begin
        if (a) q_reg <= 1'b1;
        else q_reg <= 1'b0;
    end

endmodule
