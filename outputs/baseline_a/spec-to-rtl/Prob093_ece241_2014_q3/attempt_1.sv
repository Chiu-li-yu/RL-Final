module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // K-map table:
    //      ab
    // cd  00  01  11  10
    // 00 | 0 | 0 | 0 | 1 |
    // 01 | 1 | 0 | 0 | 0 |
    // 11 | 1 | 0 | 1 | 1 |
    // 10 | 1 | 0 | 0 | 1 |
    
    // mux_in[0] corresponds to ab = 00
    // mux_in[1] corresponds to ab = 01
    // mux_in[2] corresponds to ab = 11
    // mux_in[3] corresponds to ab = 10

    // Column 00 (a=0, b=0): rows are (cd) 00, 01, 11, 10 -> values 0, 1, 1, 1
    // Function: c | d
    always @(*) mux_in[0] = c | d;

    // Column 01 (a=0, b=1): rows are (cd) 00, 01, 11, 10 -> values 0, 0, 0, 0
    // Function: 0
    always @(*) mux_in[1] = 1'b0;

    // Column 11 (a=1, b=1): rows are (cd) 00, 01, 11, 10 -> values 0, 0, 1, 0
    // Function: c & d
    always @(*) mux_in[2] = c & d;

    // Column 10 (a=1, b=0): rows are (cd) 00, 01, 11, 10 -> values 1, 0, 1, 1
    // Function: ~c | d
    always @(*) mux_in[3] = ~c | d;
endmodule
