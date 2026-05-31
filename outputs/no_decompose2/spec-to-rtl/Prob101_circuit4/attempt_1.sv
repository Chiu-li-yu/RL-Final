module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    logic q_val;
    assign q = q_val;

    always @(*) begin
        // Truth table analysis:
        // q is 1 when c is 1 (regardless of a, b, d)
        // q is 1 when b is 1 (regardless of a, c, d)
        // Essentially: q = b | c
        q_val = b | c;
    end
endmodule