module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Maybe the mux_in index is simply [0], [1], [2], [3] for columns [00], [01], [11], [10].
    // Let's try that.

    // col 0 (ab=00): c|d
    // col 1 (ab=01): 0
    // col 2 (ab=11): c&d
    // col 3 (ab=10): ~(c^d)

    always @(*) begin
        mux_in[0] = c | d;          // ab=00
        mux_in[1] = 1'b0;           // ab=01
        mux_in[2] = c & d;          // ab=11
        mux_in[3] = ~(c ^ d);       // ab=10
    end
endmodule
