module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // K-map table based on ab (rows) and cd (cols):
    //      ab
    //  cd  00  01  11  10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 0 |
    //  10 | 1 | 0 | 0 | 1 |
    
    // We want to output mux_in[0] for ab=00, mux_in[1] for ab=01, etc.
    // Looking at the K-map for each column (ab):
    // Column ab=00: row cd corresponds to output.
    // cd=00 -> 0, cd=01 -> 1, cd=11 -> 1, cd=10 -> 1
    // Logic for ab=00: (c | d)
    
    // Column ab=01: 
    // cd=00 -> 0, cd=01 -> 0, cd=11 -> 0, cd=10 -> 0
    // Logic for ab=01: 0
    
    // Column ab=11:
    // cd=00 -> 0, cd=01 -> 0, cd=11 -> 1, cd=10 -> 0
    // Logic for ab=11: (c & d)
    
    // Column ab=10:
    // cd=00 -> 1, cd=01 -> 0, cd=11 -> 0, cd=10 -> 1
    // Logic for ab=10: (~c & ~d) | (c & ~d) -> (~d) -- Wait, let's re-check
    // cd=00(0,0): 1
    // cd=01(0,1): 0
    // cd=11(1,1): 0
    // cd=10(1,0): 1
    // This is simply ~d.
    
    always @(*) begin
        mux_in[0] = (c | d);
        mux_in[1] = 1'b0;
        mux_in[2] = (c & d);
        mux_in[3] = (~d);
    end
endmodule
