module TopModule (
    input clk,
    input reset,
    output logic [4:0] q
);

    // Standard 5-bit Galois LFSR with taps at 5 and 3
    // Polynomial for length 31 (5 bits): x^5 + x^2 + 1
    // (If bit 5 is q[4] and bit 3 is q[2])
    // The bits shift right: q[4], q[3], q[2], q[1], q[0]
    // Feedback: q[0] is the shift-out bit
    // next_q[4] = q[0]
    // next_q[3] = q[4]
    // next_q[2] = q[3] ^ q[0]
    // next_q[1] = q[2]
    // next_q[0] = q[1]

    // Wait, the specification says "taps at bit positions 5 and 3". 
    // Usually these refer to the exponent in the polynomial: x^5 + x^3 + 1 (for 5 bits, maybe x^5+x^2+1 is 5 and 2).
    // Let's try x^5 + x^2 + 1 (taps at 5 and 2, bits q[4] and q[1]).
    // The spec says "taps at bit positions 5 and 3". Let's stick to that literally.
    // If bits are q[4], q[3], q[2], q[1], q[0]:
    // Tap 5 means q[4] XOR q[0]
    // Tap 3 means q[2] XOR q[0]
    // Shift right:
    // next_q[4] = q[0]
    // next_q[3] = q[4]
    // next_q[2] = q[3] ^ q[0]
    // next_q[1] = q[2]
    // next_q[0] = q[1]

    logic [4:0] next_q;

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 5'd1;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        next_q[4] = q[0];
        next_q[3] = q[4];
        next_q[2] = q[3] ^ q[0];
        next_q[1] = q[2];
        next_q[0] = q[1];
    end
endmodule
