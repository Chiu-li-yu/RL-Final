module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    logic out_temp;

    always @(*) begin
        // K-map table analysis:
        // Input order: abcd
        // ab\cd | 00 01 11 10
        // 00    | 1  1  0  1
        // 01    | 1  0  0  1
        // 11    | 0  1  1  1
        // 10    | 1  1  0  0

        // Minimized Boolean Expression (using K-map grouping):
        // F = (!a&!b&!c) | (!a&!c&!d) | (a&b&c) | (a&!c&!d) | (!b&c&d) | (b&!c&d)
        // Refined grouping:
        // 1s at: 0000, 0001, 0010, 0100, 0110, 1000, 1001, 1101, 1110, 1111
        // Simplified Logic:
        // out = (!a & !c) | (!b & !c) | (a & b & d) | (!a & b & c & d) | (a & !b & c & !d)
        // Let's re-evaluate based on the table directly:
        // Groups:
        // (!a & !c & !d) 
        // (!a & !b & !c)
        // (a & b & c)
        // (a & !c & !d)
        // (b & !c & d)
        // (!b & c & d)
        
        // Let's try sum of products logic from the map:
        out_temp = (~a & ~b & ~c) | (~a & ~c & ~d) | (a & b & c) | (a & ~c & ~d) | (~b & c & d) | (b & ~c & d);
    end

    assign out = out_temp;
endmodule
