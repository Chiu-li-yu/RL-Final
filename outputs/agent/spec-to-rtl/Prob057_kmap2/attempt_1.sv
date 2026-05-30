module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // K-map (cd/ab):
    //      00 01 11 10
    // 00 | 1  1  0  1
    // 01 | 1  0  0  1
    // 11 | 0  1  1  1
    // 10 | 1  1  0  0

    // Logic implementation
    // Minimized logic expression derived from K-map:
    // out = (~a & ~c) | (~b & ~d) | (a & c & d) | (b & c & ~d)
    
    logic out_val;
    always @(*) begin
        out_val = (~a & ~c) | (~b & ~d) | (a & c & d) | (b & c & ~d);
    end
    
    assign out = out_val;
endmodule
