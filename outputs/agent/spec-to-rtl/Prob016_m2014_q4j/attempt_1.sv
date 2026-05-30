module TopModule (
    input logic [3:0] x,
    input logic [3:0] y,
    output logic [4:0] sum
);
    logic [4:0] carry;

    // Full Adder logic using bitwise operations
    assign carry[0] = 0;
    
    // Generate sum and carry for each bit
    always @(*) begin
        sum[0] = x[0] ^ y[0] ^ carry[0];
        carry[1] = (x[0] & y[0]) | (carry[0] & (x[0] ^ y[0]));
        
        sum[1] = x[1] ^ y[1] ^ carry[1];
        carry[2] = (x[1] & y[1]) | (carry[1] & (x[1] ^ y[1]));
        
        sum[2] = x[2] ^ y[2] ^ carry[2];
        carry[3] = (x[2] & y[2]) | (carry[2] & (x[2] ^ y[2]));
        
        sum[3] = x[3] ^ y[3] ^ carry[3];
        carry[4] = (x[3] & y[3]) | (carry[3] & (x[3] ^ y[3]));
        
        sum[4] = carry[4];
    end
endmodule
