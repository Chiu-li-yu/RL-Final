module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // K-map Analysis:
    // ab=00 (mux_in[0]): row c=0,1; col d=0,1 -> 0,1,1,1 -> c | d
    // ab=01 (mux_in[1]): row c=0,1; col d=0,1 -> 0,0,0,0 -> 0
    // ab=10 (mux_in[2]): row c=0,1; col d=0,1 -> 1,0,0,1 -> ~d
    // ab=11 (mux_in[3]): row c=0,1; col d=0,1 -> 0,0,1,0 -> c & d

    always @(*) begin
        mux_in[0] = c | d;
        mux_in[1] = 1'b0;
        mux_in[2] = ~d;
        mux_in[3] = c & d;
    end
endmodule
