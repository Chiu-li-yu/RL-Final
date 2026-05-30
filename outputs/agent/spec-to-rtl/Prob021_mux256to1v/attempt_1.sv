module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);
    // 256-to-1 multiplexer, each input is 4 bits
    // sel is 8 bits (0-255)
    // in is 1024 bits total (256 * 4)
    
    always @(*) begin
        out = in[sel*4 +: 4];
    end
endmodule
