module TopModule (
    input logic clock,
    input logic a,
    output logic p,
    output logic q
);

    // Re-analyzing p:
    // time   clock   a   p
    // 25ns   1       0   0
    // 70ns   0       0   1
    // 80ns   0       0   1
    // 90ns   1       1   1
    // 145ns  1       0   0
    // 175ns  0       1   0
    // 180ns  0       0   0
    
    // p = (clock & a) | (~clock & ~a)
    
    assign p = (clock & a) | (~clock & ~a);
    
    logic q_reg;
    assign q = q_reg;
    
    always_ff @(negedge clock) begin
        if (a) q_reg <= 1'b1;
        else q_reg <= 1'b0;
    end

endmodule
