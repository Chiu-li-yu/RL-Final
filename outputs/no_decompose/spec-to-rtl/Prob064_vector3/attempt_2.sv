module TopModule (
    input logic [4:0] a,
    input logic [4:0] b,
    input logic [4:0] c,
    input logic [4:0] d,
    input logic [4:0] e,
    input logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    logic [31:0] combined;

    always @(*) begin
        // Concatenate inputs (30 bits) and add two 1s at LSB (total 32 bits)
        // Bit index 31 down to 0
        // {a, b, c, d, e, f, 2'b11}
        combined = {a, b, c, d, e, f, 2'b11};
        
        // Split into 4 8-bit outputs
        // Order: w is most significant byte, z is least significant byte?
        // Let's verify the order.
        {w, x, y, z} = combined;
    end

endmodule
