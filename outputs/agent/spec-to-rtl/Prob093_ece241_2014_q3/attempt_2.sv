module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Based on K-map analysis:
    // Col 00: c | d
    // Col 01: 0
    // Col 11: c & d
    // Col 10: ~(c ^ d)
    
    always @(*) begin
        mux_in[0] = c | d;
        mux_in[1] = 1'b0;
        mux_in[2] = c & d;
        mux_in[3] = ~(c ^ d);
    end
endmodule
