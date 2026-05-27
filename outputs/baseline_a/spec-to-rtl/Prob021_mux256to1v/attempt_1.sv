module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    // 256 4-bit inputs packed into 1024 bits.
    // Index i corresponds to bits [(i+1)*4 - 1 : i*4]
    // The selection can be done by using the index `sel` to shift
    // or by accessing the array representation.
    // Verilog allows selecting a slice of a vector using a variable index
    // if it is synthesized properly.
    
    always @(*) begin
        // Since sel is 8 bits (0-255), we can use it to index the 256 elements.
        // Each element is 4 bits wide.
        // We can cast 'in' to a 2D array or use the part-select syntax.
        // The part-select syntax `in[sel*4 +: 4]` is the standard way to do this.
        out = in[sel * 4 +: 4];
    end

endmodule
