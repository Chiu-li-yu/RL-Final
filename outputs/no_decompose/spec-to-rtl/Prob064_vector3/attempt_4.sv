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

    // The total is 30 bits of inputs.
    // The outputs are 4 * 8 = 32 bits.
    // 30 bits + 2 bits = 32 bits.
    
    // Spec: "concatenation of the input vectors followed by two 1 bits (the two 1 bits should be in the LSB positions)."
    // Let's assume input order is a,b,c,d,e,f from MSB to LSB.
    // combined = {a, b, c, d, e, f, 2'b11};
    // 32 bits: [31:27]a [26:22]b [21:17]c [16:12]d [11:7]e [6:2]f [1:0]11
    
    // If output is {w, x, y, z}, then w is [31:24], x is [23:16], y is [15:8], z is [7:0].
    
    // Maybe the order of inputs inside the concatenation or the output order is different.
    // Let's try reversing z or the whole concatenation.
    
    logic [31:0] combined;

    always @(*) begin
        combined = {a, b, c, d, e, f, 2'b11};
        // Maybe the output bits are ordered differently?
        // Let's re-read: "concatenation of the input vectors followed by two 1 bits"
        // Let's try reversing bits? No, it says concatenation.
        
        // Wait, could it be z is MSB?
        {z, y, x, w} = combined;
    end

endmodule
