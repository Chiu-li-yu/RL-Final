module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);

// K-map table (ab as selector):
// ab | cd=00 | cd=01 | cd=11 | cd=10
// 00 |   0   |   1   |   1   |   1
// 01 |   0   |   0   |   0   |   0
// 11 |   0   |   0   |   1   |   0
// 10 |   1   |   0   |   0   |   1

// mux_in[0] (ab=00): c=0,d=0 -> 0; c=0,d=1 -> 1; c=1,d=1 -> 1; c=1,d=0 -> 1
// Logic for ab=00: c | d
// mux_in[1] (ab=01): All 0
// mux_in[2] (ab=11): c=0,d=0 -> 0; c=0,d=1 -> 0; c=1,d=1 -> 1; c=1,d=0 -> 0
// Logic for ab=11: c & d
// mux_in[3] (ab=10): c=0,d=0 -> 1; c=0,d=1 -> 0; c=1,d=1 -> 0; c=1,d=0 -> 1
// Logic for ab=10: ~(c ^ d)

always @(*) begin
    mux_in[0] = c | d;
    mux_in[1] = 1'b0;
    mux_in[2] = c & d;
    mux_in[3] = ~(c ^ d);
end

endmodule