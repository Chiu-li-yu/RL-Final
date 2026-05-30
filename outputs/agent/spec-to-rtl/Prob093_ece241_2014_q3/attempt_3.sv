module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Based on K-map:
    // col 00 (ab=00): c|d
    // col 01 (ab=01): 0
    // col 10 (ab=10): ~(c^d)
    // col 11 (ab=11): c&d
    
    always @(*) begin
        mux_in[0] = c | d;
        mux_in[1] = 1'b0;
        mux_in[2] = ~(c ^ d);
        mux_in[3] = c & d;
    end
endmodule
