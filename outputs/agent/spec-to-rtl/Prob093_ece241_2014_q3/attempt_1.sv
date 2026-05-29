module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);

    always @(*) begin
        // ab = 00 -> mux_in[0]: f(0,0,c,d) = c | d
        mux_in[0] = c ? 1'b1 : d;
        
        // ab = 01 -> mux_in[1]: f(0,1,c,d) = 0
        mux_in[1] = 1'b0;
        
        // ab = 10 -> mux_in[2]: f(1,0,c,d) = c | ~d
        mux_in[2] = d ? c : 1'b1;
        
        // ab = 11 -> mux_in[3]: f(1,1,c,d) = c & d
        mux_in[3] = c ? d : 1'b0;
    end

endmodule
