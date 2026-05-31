module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // Let's re-map based on the indices 0, 1, 2, 3 corresponding to binary 00, 01, 10, 11 (ab)
    // The problem says:
    // ab = 00 -> mux_in[0]
    // ab = 01 -> mux_in[1]
    // ab = 10 -> mux_in[2]
    // ab = 11 -> mux_in[3]
    
    // K-map:
    //      ab
    //  cd  00  01  11  10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 0 |
    //  10 | 1 | 0 | 0 | 1 |
    
    // Column 00 (ab=00):
    // cd=00 -> 0
    // cd=01 -> 1
    // cd=11 -> 1
    // cd=10 -> 1
    // Logic: c | d
    
    // Column 01 (ab=01):
    // cd=00 -> 0
    // cd=01 -> 0
    // cd=11 -> 0
    // cd=10 -> 0
    // Logic: 0
    
    // Column 10 (ab=10) -- Note: Column 10 is the 4th column in K-map:
    // cd=00 -> 1
    // cd=01 -> 0
    // cd=11 -> 0
    // cd=10 -> 1
    // Logic: ~d
    
    // Column 11 (ab=11) -- Note: Column 11 is the 3rd column in K-map:
    // cd=00 -> 0
    // cd=01 -> 0
    // cd=11 -> 1
    // cd=10 -> 0
    // Logic: c & d
    
    // So if the MUX expects [3:0] as [ab=11, ab=10, ab=01, ab=00]...
    // The prompt says: "ab = 00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // "and so in" implies 10 -> mux_in[2] and 11 -> mux_in[3].
    
    always @(*) begin
        mux_in[0] = (c | d); // ab=00
        mux_in[1] = 1'b0;    // ab=01
        mux_in[2] = (~d);    // ab=10 (from column 10 in map)
        mux_in[3] = (c & d); // ab=11 (from column 11 in map)
    end
endmodule
