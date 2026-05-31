module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // K-map table based on ab (selectors):
    // cd | 00(mux_in[0]) | 01(mux_in[1]) | 11(mux_in[3]) | 10(mux_in[2])
    // ----------------------------------------------------------------
    // 00 |      0        |       0       |       0       |      1
    // 01 |      1        |       0       |       0       |      0
    // 11 |      1        |       0       |       1       |      0
    // 10 |      1        |       0       |       0       |      1

    // Row cd:
    // 00: mux_in[0]=0, mux_in[1]=0, mux_in[2]=1, mux_in[3]=0
    // 01: mux_in[0]=1, mux_in[1]=0, mux_in[2]=0, mux_in[3]=0
    // 11: mux_in[0]=1, mux_in[1]=0, mux_in[2]=0, mux_in[3]=1
    // 10: mux_in[0]=1, mux_in[1]=0, mux_in[2]=1, mux_in[3]=0

    // Logic equations for each mux_in bit based on inputs c, d:
    // mux_in[0] = (!c & d) | (c & d) | (c & !d) = d | (c & !d) = c | d
    // mux_in[1] = 0
    // mux_in[2] = (!c & !d) | (c & !d) = !d
    // mux_in[3] = (c & d)

    always @(*) begin
        mux_in[0] = c | d;
        mux_in[1] = 1'b0;
        mux_in[2] = ~d;
        mux_in[3] = c & d;
    end

endmodule
