module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);

    always @(*) begin
        // K-map columns: 00, 01, 11, 10
        // Mapping "and so on" to the K-map column order:
        // mux_in[0] = ab 00
        // mux_in[1] = ab 01
        // mux_in[2] = ab 11
        // mux_in[3] = ab 10
        
        // Col 00: 0, 1, 1, 1 -> c | d
        mux_in[0] = c ? 1'b1 : d;
        
        // Col 01: 0, 0, 0, 0 -> 0
        mux_in[1] = 1'b0;
        
        // Col 11: 0, 0, 1, 0 -> c & d
        mux_in[2] = c ? d : 1'b0;
        
        // Col 10: 1, 0, 1, 1 -> c | ~d
        mux_in[3] = d ? c : 1'b1;
    end

endmodule
