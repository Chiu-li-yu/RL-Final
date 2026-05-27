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
    // 30 bits input + 2 bits constant = 32 bits
    // The concatenation order is {a, b, c, d, e, f, 2'b11}
    // a[4] is MSB, constant 1 is LSB.
    logic [31:0] combined;

    always @(*) begin
        combined = {a, b, c, d, e, f, 2'b11};
        
        // Split 32-bit combined vector into 4 8-bit outputs
        // MSB side to w, LSB side to z
        w = combined[31:24];
        x = combined[23:16];
        y = combined[15:8];
        z = combined[7:0];
    end
endmodule
