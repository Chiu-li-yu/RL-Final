module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    logic q_val;
    always @(*) begin
        // Truth table analysis:
        // Input: a b c d | q
        //        0 0 0 0 | 0
        //        ...
        //        0 1 0 1 | 1
        //        0 1 1 0 | 1
        //        0 1 1 1 | 1
        //        1 0 0 1 | 1
        //        1 0 1 0 | 1
        //        1 0 1 1 | 1
        //        1 1 0 1 | 1
        //        1 1 1 0 | 1
        //        1 1 1 1 | 1
        
        // This looks like q = (a|b) & (c|d)
        // Let's test this hypothesis:
        // (0|1) & (0|1) = 1 & 1 = 1 (40ns, 45ns, 50ns)
        // (1|0) & (0|1) = 1 & 1 = 1 (60ns, 65ns, 70ns)
        // (1|1) & (0|1) = 1 & 1 = 1 (80ns, 85ns, 90ns)
        // Seems correct.
        q_val = (a | b) & (c | d);
    end

    assign q = q_val;

endmodule
