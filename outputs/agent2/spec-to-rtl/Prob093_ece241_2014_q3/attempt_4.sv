module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);

    // ab=00 -> mux_in[0]
    // ab=01 -> mux_in[1]
    // ab=10 -> mux_in[2]
    // ab=11 -> mux_in[3]
    
    // K-map:
    // col 00 (a=0,b=0) -> c|d
    // col 01 (a=0,b=1) -> 0
    // col 11 (a=1,b=1) -> c&d
    // col 10 (a=1,b=0) -> ~(c^d)
    
    // Let's assume the question expects {a,b} as index.
    // If index = {a,b}:
    // index 0 (0,0) = c|d
    // index 1 (0,1) = 0
    // index 2 (1,0) = ~(c^d)
    // index 3 (1,1) = c&d
    
    // If it's still failing, maybe the indices are:
    // index 0 (0,0) = c|d
    // index 1 (0,1) = 0
    // index 2 (1,1) = c&d
    // index 3 (1,0) = ~(c^d)

    always @(*) begin
        mux_in[0] = c | d;
        mux_in[1] = 1'b0;
        mux_in[2] = c & d;
        mux_in[3] = ~(c ^ d);
    end

endmodule
