module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);

    always @(*) begin
        // Hypothesizing that the K-map rows are ab and cols are cd.
        // Rows ab: 00, 01, 11, 10
        // Cols cd: 00, 01, 11, 10
        
        // Row 1 (ab=00): 0, 0, 0, 1 -> c & ~d
        mux_in[0] = c ? (d ? 1'b0 : 1'b1) : 1'b0;
        
        // Row 2 (ab=01): 1, 0, 0, 0 -> ~c & ~d
        mux_in[1] = (c ? 1'b0 : 1'b1) ? (d ? 1'b0 : 1'b1) : 1'b0;
        
        // Row 4 (ab=10): 1, 0, 0, 1 -> ~d
        mux_in[2] = d ? 1'b0 : 1'b1;
        
        // Row 3 (ab=11): 1, 0, 1, 1 -> c | ~d
        mux_in[3] = d ? c : 1'b1;
    end

endmodule
