module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    always @(*) begin
        // The selection logic needs to map sel to the correct 4-bit chunk.
        // sel is 8 bits (0-255), total 1024 bits (256 * 4 bits).
        // Since sel can be up to 255, we index into the 1024-bit array.
        // in[sel*4 + 3 : sel*4] is not valid syntax in Verilog for variable slicing.
        // We can use a generate block or a shift/mask approach.
        
        // Approach: shift right and mask
        out = (in >> (sel * 4)) & 4'hF;
    end

endmodule
