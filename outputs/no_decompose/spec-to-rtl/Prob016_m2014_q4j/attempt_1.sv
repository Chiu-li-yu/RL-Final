module TopModule (
    input logic [3:0] x,
    input logic [3:0] y,
    output logic [4:0] sum
);

    logic [4:0] carry;

    assign carry[0] = 1'b0;

    // Full Adder logic for each bit
    // Using generate-like block logic inside always_comb is not needed
    // Simple assignment
    
    // Bit 0
    assign sum[0] = x[0] ^ y[0] ^ carry[0];
    assign carry[1] = (x[0] & y[0]) | (carry[0] & (x[0] ^ y[0]));
    
    // Bit 1
    assign sum[1] = x[1] ^ y[1] ^ carry[1];
    assign carry[2] = (x[1] & y[1]) | (carry[1] & (x[1] ^ y[1]));
    
    // Bit 2
    assign sum[2] = x[2] ^ y[2] ^ carry[2];
    assign carry[3] = (x[2] & y[2]) | (carry[2] & (x[2] ^ y[2]));
    
    // Bit 3
    assign sum[3] = x[3] ^ y[3] ^ carry[3];
    assign carry[4] = (x[3] & y[3]) | (carry[3] & (x[3] ^ y[3]));
    
    // Overflow / MSB
    assign sum[4] = carry[4];

endmodule
