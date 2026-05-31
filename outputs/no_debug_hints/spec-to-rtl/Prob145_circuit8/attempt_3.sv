module TopModule (
    input logic clock,
    input logic a,
    output logic p,
    output logic q
);
    // Let's re-examine the table again.
    // 85ns: clock=1, a=0, p=0, q=0
    // 90ns: clock=1, a=1, p=1, q=0
    // 110ns: clock=1, a=1, p=1, q=0
    // 115ns: clock=0, a=0, p=1, q=1
    // 120ns: clock=0, a=1, p=1, q=1
    
    // Looks like q is a FF that latches (p & ~clock) when clock goes low or something similar?
    // Actually, at 115ns, q becomes 1 when clock=0 and p was 1. 
    // And it stays 1 as long as it's not reset?
    // 175ns: clock=0, a=1, p=0, q=0. It resets!
    
    logic q_reg;
    assign q = q_reg;
    assign p = a & clock;
    
    always_ff @(negedge clock) begin
        if (a) q_reg <= 1'b1;
        else q_reg <= 1'b0;
    end

endmodule
