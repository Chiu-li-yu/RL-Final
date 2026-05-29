module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);

    always @(*) begin
        // Try mapping based on ba instead of ab:
        // mux_in[0]: ab=00 (c | d)
        // mux_in[1]: ab=10 (c | ~d)
        // mux_in[2]: ab=01 (0)
        // mux_in[3]: ab=11 (c & d)
        
        mux_in[0] = c ? 1'b1 : d;
        mux_in[1] = d ? c : 1'b1;
        mux_in[2] = 1'b0;
        mux_in[3] = c ? d : 1'b0;
    end

endmodule
