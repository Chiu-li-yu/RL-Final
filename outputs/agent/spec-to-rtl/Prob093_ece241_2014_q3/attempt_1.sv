module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    logic [3:0] mux_in;

    always @(*) begin
        mux_in[0] = c | d;      // Column 00
        mux_in[1] = 1'b0;       // Column 01
        mux_in[2] = c & d;      // Column 11
        mux_in[3] = ~(c ^ d);   // Column 10
    end

    assign out = (a == 0 && b == 0) ? mux_in[0] :
                 (a == 0 && b == 1) ? mux_in[1] :
                 (a == 1 && b == 1) ? mux_in[2] :
                 mux_in[3];
endmodule
