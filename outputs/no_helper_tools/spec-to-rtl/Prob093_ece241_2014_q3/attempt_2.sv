module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Re-reading K-map:
    //      ab
    //  cd  00  01  11  10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 0 |
    //  10 | 1 | 0 | 0 | 1 |

    // The columns are labeled ab = 00, 01, 11, 10
    // mux_in[0] corresponds to column 00
    // mux_in[1] corresponds to column 01
    // mux_in[2] corresponds to column 11
    // mux_in[3] corresponds to column 10

    // Row cd values:
    // 00: c=0, d=0
    // 01: c=0, d=1
    // 11: c=1, d=1
    // 10: c=1, d=0

    // Column 00 (mux_in[0]):
    // (0,0) -> 0
    // (0,1) -> 1
    // (1,1) -> 1
    // (1,0) -> 1
    // This is c | d

    // Column 01 (mux_in[1]):
    // (0,0) -> 0
    // (0,1) -> 0
    // (1,1) -> 0
    // (1,0) -> 0
    // This is 0

    // Column 11 (mux_in[2]):
    // (0,0) -> 0
    // (0,1) -> 0
    // (1,1) -> 1
    // (1,0) -> 0
    // This is c & d

    // Column 10 (mux_in[3]):
    // (0,0) -> 1
    // (0,1) -> 0
    // (1,1) -> 0
    // (1,0) -> 1
    // This is ~d

    always @(*) begin
        mux_in[0] = (c | d);
        mux_in[1] = 1'b0;
        mux_in[2] = (c & d);
        mux_in[3] = (~d);
    end
endmodule
