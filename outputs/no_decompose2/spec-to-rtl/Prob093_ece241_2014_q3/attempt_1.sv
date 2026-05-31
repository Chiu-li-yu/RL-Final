module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // K-map (ab as selector for 4-to-1 mux)
    // ab=00 (col 0): c=0,d=0 -> 0; c=0,d=1 -> 1; c=1,d=1 -> 1; c=1,d=0 -> 1.
    // Logic for col 0 (ab=00): output is 1 if (c=1 OR d=1) AND NOT(c=1 AND d=0).
    // Let's re-read the table:
    // row (cd) \ ab | 00 | 01 | 11 | 10
    // 00             |  0 |  0 |  0 |  1
    // 01             |  1 |  0 |  0 |  0
    // 11             |  1 |  0 |  1 |  0
    // 10             |  1 |  0 |  0 |  1

    // For ab=00:
    // cd=00 -> 0
    // cd=01 -> 1
    // cd=11 -> 1
    // cd=10 -> 1
    // So mux_in[0] = c | d

    // For ab=01:
    // cd=00 -> 0
    // cd=01 -> 0
    // cd=11 -> 0
    // cd=10 -> 0
    // So mux_in[1] = 0

    // For ab=11:
    // cd=00 -> 0
    // cd=01 -> 0
    // cd=11 -> 1
    // cd=10 -> 0
    // So mux_in[2] = c & d

    // For ab=10:
    // cd=00 -> 1
    // cd=01 -> 0
    // cd=11 -> 0
    // cd=10 -> 1
    // So mux_in[3] = ~(c ^ d)

    always @(*) begin
        mux_in[0] = c | d;
        mux_in[1] = 1'b0;
        mux_in[2] = c & d;
        mux_in[3] = ~(c ^ d);
    end
endmodule
