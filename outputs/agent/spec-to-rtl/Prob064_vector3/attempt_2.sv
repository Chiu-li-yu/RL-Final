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
        // The concatenation order should be: {a, b, c, d, e, f, 1, 1}
        // Total 30 bits + 2 bits = 32 bits
        combined = {a, b, c, d, e, f, 2'b11};
        
        // Output w is MSB, z is LSB
        w = combined[31:24];
        x = combined[23:16];
        y = combined[15:8];
        z = combined[7:0];
    end
endmodule
