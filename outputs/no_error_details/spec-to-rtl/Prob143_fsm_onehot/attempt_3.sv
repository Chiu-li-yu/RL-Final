module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);
    // S0, S1, S2, S3, S4, S5, S6, S7, S8, S9
    // Index: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

    logic [9:0] next_bits;
    
    always @(*) begin
        next_bits = 10'b0;
        if (state[0]) next_bits |= (in ? 10'b0000000010 : 10'b0000000001);
        if (state[1]) next_bits |= (in ? 10'b0000000100 : 10'b0000000001);
        if (state[2]) next_bits |= (in ? 10'b0000001000 : 10'b0000000001);
        if (state[3]) next_bits |= (in ? 10'b0000010000 : 10'b0000000001);
        if (state[4]) next_bits |= (in ? 10'b0000100000 : 10'b0000000001);
        if (state[5]) next_bits |= (in ? 10'b0001000000 : 10'b000100000000); // 1->S6, 0->S8
        if (state[6]) next_bits |= (in ? 10'b10000000 : 10'b1000000000);   // 1->S7, 0->S9
        // Wait, index 7 is S7, index 8 is S8, index 9 is S9
        // S5: 1->S6(6), 0->S8(8)
        // S6: 1->S7(7), 0->S9(9)
        // Corrected:
    end

    // Correcting indices for S6, S7, S8, S9
    // 0:S0, 1:S1, 2:S2, 3:S3, 4:S4, 5:S5, 6:S6, 7:S7, 8:S8, 9:S9
    
    always @(*) begin
        next_bits = 10'b0;
        // S0-S4
        if (state[0]) next_bits |= (in ? 10'b0000000010 : 10'b0000000001);
        if (state[1]) next_bits |= (in ? 10'b0000000100 : 10'b0000000001);
        if (state[2]) next_bits |= (in ? 10'b0000001000 : 10'b0000000001);
        if (state[3]) next_bits |= (in ? 10'b0000010000 : 10'b0000000001);
        if (state[4]) next_bits |= (in ? 10'b0000100000 : 10'b0000000001);
        // S5: 1->S6, 0->S8
        if (state[5]) next_bits |= (in ? 10'b0001000000 : 10'b000100000000);
        // S6: 1->S7, 0->S9
        if (state[6]) next_bits |= (in ? 10'b10000000 : 10'b1000000000);
        // S7: 1->S7, 0->S0
        if (state[7]) next_bits |= (in ? 10'b10000000 : 10'b0000000001);
        // S8: 1->S1, 0->S0
        if (state[8]) next_bits |= (in ? 10'b0000000010 : 10'b0000000001);
        // S9: 1->S1, 0->S0
        if (state[9]) next_bits |= (in ? 10'b0000000010 : 10'b0000000001);
    end
    
    assign next_state = next_bits;
    
    // Output logic
    // S7 (0,1), S8 (1,0), S9 (1,1)
    assign out1 = (state[8] || state[9]);
    assign out2 = (state[7] || state[9]);

endmodule
