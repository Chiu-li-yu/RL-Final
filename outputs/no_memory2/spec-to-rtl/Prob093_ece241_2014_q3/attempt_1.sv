module TopModule (
    input a,
    input b,
    input c,
    input d,
    output [3:0] mux_in,
    output out
);
    // According to analysis:
    // mux_in[0] (when ab=00) corresponds to c | d
    // mux_in[1] (when ab=01) corresponds to 0
    // mux_in[2] (when ab=10) corresponds to ~(c ^ d)
    // mux_in[3] (when ab=11) corresponds to c & d
    
    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = ~(c ^ d);
    assign mux_in[3] = c & d;
    
    // 4-to-1 Mux
    assign out = ({a, b} == 2'b00) ? mux_in[0] :
                 ({a, b} == 2'b01) ? mux_in[1] :
                 ({a, b} == 2'b10) ? mux_in[2] : mux_in[3];

endmodule