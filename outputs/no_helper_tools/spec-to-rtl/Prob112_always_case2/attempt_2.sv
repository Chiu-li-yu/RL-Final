module TopModule (
    input logic [3:0] in,
    output logic [1:0] pos
);

    always @(*) begin
        // Priority encoder: output the position of the *highest* bit that is set.
        // Wait, the specification says "first 1 bit" and gives an example:
        // "8'b10010000 would output 3'd4, because bit[4] is first bit that is high".
        // This implies index from right to left (bit[0] is the 0th position).
        // Let's re-interpret the example:
        // bit 7 6 5 4 3 2 1 0
        //     1 0 0 1 0 0 0 0
        // The example says bit[4] is the first bit high.
        // If it was bit[7], it would be index 7. 
        // So "first 1 bit" likely means the most significant bit.
        
        // Let's try the logic for MSB:
        if (in[3]) begin
            pos = 2'd3;
        end else if (in[2]) begin
            pos = 2'd2;
        end else if (in[1]) begin
            pos = 2'd1;
        end else begin
            pos = 2'd0;
        end
    end

endmodule
