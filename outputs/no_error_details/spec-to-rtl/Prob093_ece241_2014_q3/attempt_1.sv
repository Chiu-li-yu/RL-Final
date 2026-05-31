module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // K-map Analysis:
    // Columns (ab):
    // 00: c=0,d=0 -> 0; c=0,d=1 -> 1; c=1,d=1 -> 1; c=1,d=0 -> 1
    //     Logic: mux_in[0] = c | d  (Actually check: c=0,d=0=0; 0,1=1; 1,1=1; 1,0=1. Matches.)
    // 01: All 0 -> mux_in[1] = 0
    // 11: c=0,d=0 -> 0; c=0,d=1 -> 0; c=1,d=1 -> 1; c=1,d=0 -> 0
    //     Logic: mux_in[2] = c & d
    // 10: c=0,d=0 -> 1; c=0,d=1 -> 0; c=1,d=1 -> 0; c=1,d=0 -> 1
    //     Logic: mux_in[3] = ~(c ^ d) or (~c & ~d) | (c & d)

    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c & d;
    assign mux_in[3] = ~(c ^ d);

endmodule