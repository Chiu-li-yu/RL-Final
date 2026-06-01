module TopModule (
    input a,
    input b,
    input c,
    output out
);
    logic out_temp;

    always @(*) begin
        // K-Map Truth Table:
        // a=0: (bc=00:0, 01:1, 11:1, 10:1) -> 0, 1, 1, 1
        // a=1: (bc=00:1, 01:1, 11:1, 10:1) -> 1, 1, 1, 1
        // Simplified Logic: 
        // 000: 0
        // 001: 1
        // 011: 1
        // 010: 1
        // 100: 1
        // 101: 1
        // 111: 1
        // 110: 1
        // It's equivalent to (a | (b | c)) ? No, let's check
        // 000 -> 0
        // 001 -> 1
        // 010 -> 1
        // 011 -> 1
        // 100 -> 1
        // 101 -> 1
        // 110 -> 1
        // 111 -> 1
        // The output is 0 only when a=0, b=0, c=0.
        // Therefore, out = a | b | c
        out_temp = a | b | c;
    end

    assign out = out_temp;
endmodule
