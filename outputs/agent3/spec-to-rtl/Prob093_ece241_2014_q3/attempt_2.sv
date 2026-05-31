module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);

    // K-map analysis for mapping:
    // col 00 (a=0,b=0): row cd 00->0, 01->1, 11->1, 10->1 => c | d
    // col 01 (a=0,b=1): row cd 00->0, 01->0, 11->0, 10->0 => 0
    // col 10 (a=1,b=0): row cd 00->1, 01->0, 11->0, 10->1 => ~(c ^ d)
    // col 11 (a=1,b=1): row cd 00->0, 01->0, 11->1, 10->0 => c & d

    always @(*) begin
        mux_in[0] = c | d;      // ab = 00
        mux_in[1] = 1'b0;       // ab = 01
        mux_in[2] = ~(c ^ d);   // ab = 10
        mux_in[3] = c & d;      // ab = 11
    end

endmodule
