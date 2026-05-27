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
        // Concatenate inputs (30 bits) and two 1 bits (2 bits) to make 32 bits
        combined = {a, b, c, d, e, f, 2'b11};
        
        // Split 32-bit into four 8-bit outputs
        // Order: {a, b, c, d, e, f, 2'b11}
        // w is MSB, z is LSB
        {w, x, y, z} = combined;
    end

endmodule
