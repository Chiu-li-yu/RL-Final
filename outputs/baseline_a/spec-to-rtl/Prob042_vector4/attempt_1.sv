module TopModule (
    input  logic [7:0] in,
    output logic [31:0] out
);
    // Sign-extend an 8-bit number to 32 bits.
    // Replicate the sign bit (in[7]) 24 times and concatenate with the 8-bit input.
    always @(*) begin
        out = {{24{in[7]}}, in};
    end
endmodule
