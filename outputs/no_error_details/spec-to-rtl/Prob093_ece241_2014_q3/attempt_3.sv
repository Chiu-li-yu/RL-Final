module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // K-map:
    // row 0: cd=00
    // row 1: cd=01
    // row 2: cd=11
    // row 3: cd=10

    // ab=00 (mux_in[0]): row0=0, row1=1, row2=1, row3=1
    // row0: c=0,d=0 -> 0
    // row1: c=0,d=1 -> 1
    // row2: c=1,d=1 -> 1
    // row3: c=1,d=0 -> 1
    // Logic: c | d

    // ab=01 (mux_in[1]): row0=0, row1=0, row2=0, row3=0
    // Logic: 0

    // ab=11 (mux_in[2]): row0=0, row1=0, row2=1, row3=0
    // row0: c=0,d=0 -> 0
    // row1: c=0,d=1 -> 0
    // row2: c=1,d=1 -> 1
    // row3: c=1,d=0 -> 0
    // Logic: c & d

    // ab=10 (mux_in[3]): row0=1, row1=0, row2=0, row3=1
    // row0: c=0,d=0 -> 1
    // row1: c=0,d=1 -> 0
    // row2: c=1,d=1 -> 0
    // row3: c=1,d=0 -> 1
    // Logic: c == d (XNOR: ~(c^d))

    // Note: The problem states "ab=00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // 00 -> 0, 01 -> 1, 10 -> 2, 11 -> 3
    // Wait, the specification says "ab=01 is connected to mux_in[1], and so in" 
    // Usually "so in" implies 10->mux_in[2] and 11->mux_in[3].
    // My previous mapping used 11->mux_in[2] and 10->mux_in[3]. 
    // Let's swap index 2 and 3 based on 00, 01, 10, 11 ordering.

    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = ~(c ^ d); // for ab=10
    assign mux_in[3] = c & d;    // for ab=11

endmodule