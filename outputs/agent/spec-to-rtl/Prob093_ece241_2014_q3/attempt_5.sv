module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);

    always @(*) begin
        // Try mapping where K-map columns are 00, 01, 10, 11
        // mux_in[0] = Col 1 (c | d)
        // mux_in[1] = Col 2 (0)
        // mux_in[2] = Col 3 (c & d)
        // mux_in[3] = Col 4 (c | ~d)
        
        mux_in[0] = c ? 1'b1 : d;
        mux_in[1] = 1'b0;
        mux_in[2] = c ? d : 1'b0;
        mux_in[3] = d ? c : 1'b1;
    end

endmodule
