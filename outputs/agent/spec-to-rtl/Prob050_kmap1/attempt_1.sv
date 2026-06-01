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
        // 0 1 0 | 1
        // 0 1 1 | 1
        // 1 0 0 | 1
        // 1 0 1 | 1
        // 1 1 0 | 1
        // 1 1 1 | 1
        
        // Logical expression from K-map: 
        // out = a | b | c
        out_temp = a | b | c;
    end

    assign out = out_temp;
endmodule
