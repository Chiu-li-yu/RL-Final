module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    logic q_internal;

    always @(*) begin
        // Analyzed truth table:
        // When b is 0, c is 0, d is 0: q = 0
        // When b=1 or a=1:
        //   If (c or d) is 1, q = 1
        //   Else q = 0
        
        q_internal = (a | b) & (c | d);
    end

    assign q = q_internal;

endmodule
