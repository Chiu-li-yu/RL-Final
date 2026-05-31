module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // Let's re-read carefully:
    // "ab = 00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // In Verilog binary representation for a selector, ab:
    // If selector is {a,b}, then 00=0, 01=1, 10=2, 11=3.
    // So 00->mux_in[0], 01->mux_in[1], 10->mux_in[2], 11->mux_in[3].

    // K-map columns: ab 00, 01, 11, 10
    // This order is NOT 00, 01, 10, 11. 
    // It is 00, 01, 11, 10.
    // So:
    // col 00 -> mux_in[0]
    // col 01 -> mux_in[1]
    // col 11 -> mux_in[2]
    // col 10 -> mux_in[3]
    
    // K-map data:
    // col 00: (c=0,d=0)->0, (c=0,d=1)->1, (c=1,d=1)->1, (c=1,d=0)->1 => c|d
    // col 01: (c=0,d=0)->0, (c=0,d=1)->0, (c=1,d=1)->0, (c=1,d=0)->0 => 0
    // col 11: (c=0,d=0)->0, (c=0,d=1)->0, (c=1,d=1)->1, (c=1,d=0)->0 => c&d
    // col 10: (c=0,d=0)->1, (c=0,d=1)->0, (c=1,d=1)->0, (c=1,d=0)->1 => ~(c^d)

    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c & d;
    assign mux_in[3] = ~(c ^ d);

endmodule