module TopModule (
    input a,
    input b,
    input c,
    output out
);
    always @(*) begin
        // K-map analysis:
        // bc=00, a=0: 0
        // bc=00, a=1: 1
        // bc=01, a=0: 1
        // bc=01, a=1: 1
        // bc=11, a=0: 1
        // bc=11, a=1: 1
        // bc=10, a=0: 1
        // bc=10, a=1: 1
        // Boolean logic: out = a + (b | c)
        out = a | b | c;
    end
endmodule
