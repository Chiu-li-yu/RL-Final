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
        // c=1 OR (b=1 AND (a=0 OR d=1))
        // Let's re-verify:
        // c=1: 25, 30, 45, 50, 65, 70, 85, 90 (all q=1) - Matches
        // c=0, b=1: 35, 40, 75, 80 (all q=1) - Matches
        // c=0, b=0, d=1: 20 (q=0), 60 (q=0) - Wait, this doesn't match b=1 condition
        // Let's re-examine the table:
        // a b c d | q
        // 0 0 0 0 | 0
        // 0 0 0 1 | 0
        // 0 0 1 0 | 1
        // 0 0 1 1 | 1
        // 0 1 0 0 | 1
        // 0 1 0 1 | 1
        // 0 1 1 0 | 1
        // 0 1 1 1 | 1
        // 1 0 0 0 | 0
        // 1 0 0 1 | 0
        // 1 0 1 0 | 1
        // 1 0 1 1 | 1
        // 1 1 0 0 | 1
        // 1 1 0 1 | 1
        // 1 1 1 0 | 1
        // 1 1 1 1 | 1
        
        // Karnaugh Map:
        //    cd 00 01 11 10
        // ab
        // 00    0  0  1  1
        // 01    1  1  1  1
        // 11    1  1  1  1
        // 10    0  0  1  1
        
        // Grouping 1s:
        // 1. Row 01 and 11 (b=1)
        // 2. Column 10 and 11 (c=1)
        
        q_val = b | c;
    end
endmodule
