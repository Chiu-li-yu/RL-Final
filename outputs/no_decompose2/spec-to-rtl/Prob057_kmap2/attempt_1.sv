module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Karnaugh Map:
    //      ab
    // cd  00 01 11 10
    // 00 | 1 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 0 | 1 |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 1 | 1 | 0 | 0 |
    
    // Sum of Products (SOP) realization:
    // The cells with 1s:
    // (0000), (0001), (0010), (0100), (0111), (1101), (1111), (1000), (1001), (1011)
    
    // Karnaugh Map minimization:
    // Minimized Expression:
    // out = (~a & ~b & ~c) | (~b & ~c & ~d) | (a & b & d) | (a & ~c & d) | (~a & c & d) | (b & ~c & ~d) ...
    // Let's use standard SOP simplification:
    // out = (~a & ~b & ~c) | (~a & c & d) | (a & b & d) | (a & ~c & ~d) | (~b & c & ~d) | (b & c & d) ?
    
    // Re-evaluating K-Map visually:
    // 0000: 1
    // 0001: 1
    // 0010: 1
    // 0011: 0
    // 0100: 1
    // 0101: 0
    // 0110: 1
    // 0111: 1
    // 1000: 1
    // 1001: 1
    // 1010: 0
    // 1011: 1
    // 1100: 0
    // 1101: 1
    // 1110: 1
    // 1111: 1

    logic out_logic;
    always @(*) begin
        out_logic = (~a & ~b & ~c) | (~a & ~b & ~d) | (~a & c & d) | (a & b & d) | (a & c & ~d) | (b & ~c & ~d);
    end
    
    assign out = out_logic;
endmodule
