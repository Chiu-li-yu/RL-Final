module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);

    // K-map analysis:
    // col 00: (c=0,d=0)->0, (c=0,d=1)->1, (c=1,d=1)->1, (c=1,d=0)->1 => c | d
    // col 01: (c=0,d=0)->0, (c=0,d=1)->0, (c=1,d=1)->0, (c=1,d=0)->0 => 0
    // col 11: (c=0,d=0)->0, (c=0,d=1)->0, (c=1,d=1)->1, (c=1,d=0)->0 => c & d
    // col 10: (c=0,d=0)->1, (c=0,d=1)->0, (c=1,d=1)->0, (c=1,d=0)->1 => ~(c ^ d)

    always @(*) begin
        mux_in[0] = c | d;
        mux_in[1] = 1'b0;
        mux_in[2] = c & d;
        mux_in[3] = ~(c ^ d);
    end

endmodule
