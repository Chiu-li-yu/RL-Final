module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // 256 entries * 4 bits = 1024 bits
    // We can use a 2D array approach or index calculation.
    // Given the index sel:
    // sel=0 -> bits [3:0]
    // sel=1 -> bits [7:4]
    // index i starts at sel * 4.
    
    logic [3:0] out_tmp;
    
    always @(*) begin
        out_tmp = in[sel * 4 +: 4];
    end
    
    assign out = out_tmp;
endmodule