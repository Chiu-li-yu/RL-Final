module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // K-map analysis:
    // (a,b) as MSBs, (c,d) as LSBs
    // Row/Col map:
    //      ab: 00 01 11 10
    // cd: 00 | 0  1  0  1
    //     01 | 1  0  1  0
    //     11 | 0  1  0  1
    //     10 | 1  0  1  0
    //
    // From the map, the output is 1 when:
    // (00,01), (00,10), (01,00), (01,11), (11,01), (11,10), (10,00), (10,11)
    //
    // This is equivalent to an XOR pattern:
    // out = b ^ d

    always @(*) begin
        out = b ^ d;
    end

endmodule
