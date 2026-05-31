module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    logic out_val;
    assign out = out_val;

    always @(*) begin
        // K-map analysis:
        // Rows (cd): 00, 01, 11, 10
        // Cols (ab): 00, 01, 11, 10
        // Mapping (cd, ab) -> Value:
        // (00,00)=0, (00,01)=1, (00,11)=0, (00,10)=1
        // (01,00)=1, (01,01)=0, (01,11)=1, (01,10)=0
        // (11,00)=0, (11,01)=1, (11,11)=0, (11,10)=1
        // (10,00)=1, (10,01)=0, (10,11)=1, (10,10)=0
        
        // This is XOR pattern: out = a ^ c
        // Verification:
        // (c,a) -> out
        // 0,0 -> 0
        // 0,1 -> 1
        // 1,0 -> 1
        // 1,1 -> 0
        // Matches!
        out_val = a ^ c;
    end

endmodule
