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
        // Input: a b c d | q
        // ------------------
        //        0 0 0 0 | 0
        //        ...
        //        0 1 0 1 | 1
        //        0 1 1 0 | 1
        //        0 1 1 1 | 1
        //        1 0 0 1 | 1
        //        1 0 1 0 | 1
        //        1 0 1 1 | 1
        //        ...
        //        1 1 0 1 | 1
        //        1 1 1 0 | 1
        //        1 1 1 1 | 1
        
        // Pattern: q is 1 if (a=0 and b=1 and (c=1 or d=1)) OR (a=1 and (b=0 or b=1) and (c=1 or d=1))
        // Simplifies to: q = (a | b) & (c | d) AND (a | b) logic is slightly off.
        // Let's re-examine:
        // If q=1:
        // (0,1,0,1), (0,1,1,0), (0,1,1,1) -> b=1 and (c or d)
        // (1,0,0,1), (1,0,1,0), (1,0,1,1) -> a=1 and (c or d)
        // (1,1,0,1), (1,1,1,0), (1,1,1,1) -> a=1 and (c or d)
        
        // Combined: (b=1 OR a=1) AND (c=1 OR d=1)
        q_val = (a | b) & (c | d);
    end
endmodule