module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // K-map table (ab as column, cd as row):
    //     ab
    // cd  00 01 11 10
    // 00  0  0  0  1
    // 01  1  0  0  0
    // 11  1  0  1  1
    // 10  1  0  0  1

    // Columns are ab:
    // col 00 (ab=00): [0, 1, 1, 1] for cd=[00, 01, 11, 10]
    // col 01 (ab=01): [0, 0, 0, 0] for cd=[00, 01, 11, 10]
    // col 11 (ab=11): [0, 0, 1, 0] for cd=[00, 01, 11, 10]
    // col 10 (ab=10): [1, 0, 1, 1] for cd=[00, 01, 11, 10]

    // Let's define the function for each column based on c and d:
    // col 0 (ab=00): f(0,0) = (c=0,d=0)->0, (c=0,d=1)->1, (c=1,d=1)->1, (c=1,d=0)->1
    // Logic for col 0: c | d (Wait, let's re-verify)
    // cd | 00 01 11 10
    // 00 | 0
    // 01 | 1
    // 11 | 1
    // 10 | 1
    // c=0,d=0 -> 0
    // c=0,d=1 -> 1
    // c=1,d=0 -> 1
    // c=1,d=1 -> 1
    // This is simply c | d.

    // col 1 (ab=01): All 0s.

    // col 2 (ab=11): f(1,1) = (c=0,d=0)->0, (c=0,d=1)->0, (c=1,d=1)->1, (c=1,d=0)->0
    // Logic for col 2: c & d.

    // col 3 (ab=10): f(1,0) = (c=0,d=0)->1, (c=0,d=1)->0, (c=1,d=1)->1, (c=1,d=0)->1
    // Logic for col 3: !d | c

    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c & d;
    assign mux_in[3] = (~d) | c;

endmodule
