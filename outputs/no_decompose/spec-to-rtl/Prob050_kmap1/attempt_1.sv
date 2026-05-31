module TopModule (
    input a,
    input b,
    input c,
    output out
);

    logic out_temp;

    always @(*) begin
        // K-Map Truth Table:
        // a b c | out
        // 0 0 0 | 0
        // 0 0 1 | 1
        // 0 1 1 | 1
        // 0 1 0 | 1
        // 1 0 0 | 1
        // 1 0 1 | 1
        // 1 1 1 | 1
        // 1 1 0 | 1
        
        // Sum of products or simplification:
        // Cells with 1: (0,0,1), (0,1,1), (0,1,0), (1,0,0), (1,0,1), (1,1,1), (1,1,0)
        // Only (0,0,0) is 0.
        // So out = a | b | c
        out_temp = a | b | c;
    end

    assign out = out_temp;

endmodule
