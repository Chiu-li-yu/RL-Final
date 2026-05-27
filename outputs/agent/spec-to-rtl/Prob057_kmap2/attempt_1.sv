module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // K-map translation:
    //    cd \ ab | 00 | 01 | 11 | 10
    //    --------------------------
    //    00      | 1  | 1  | 0  | 1
    //    01      | 1  | 0  | 0  | 1
    //    11      | 0  | 1  | 1  | 1
    //    10      | 1  | 1  | 0  | 0
    //
    // Sum of products (minterms):
    // out = (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & ~b & c & d) | (~a & b & ~c & ~d) 
    //     | (~a & b & c & d) | (~a & b & c & ~d) | (a & ~b & ~c & ~d) | (a & ~b & ~c & d) 
    //     | (a & b & c & d) | (a & b & c & ~d) | (a & ~b & c & d)
    // 
    // Simplifying via Boolean Algebra/K-map:
    // Groupings:
    // 1. (~a & ~c) covers (00,00), (00,01), (01,00), (01,01) -- wait, no.
    // Let's use Sum of Products directly from map:
    // out = (~a & ~b & ~d) | (~a & b & c) | (a & ~b & ~c) | (a & b & d) | (~b & c & d) | (a & ~c & d)
    
    logic out_val;
    always @(*) begin
        out_val = (~a & ~b & ~d) | (~a & b & c) | (a & ~b & ~c) | (a & b & d) | (~b & c & d) | (a & ~c & d);
    end

    assign out = out_val;

endmodule
