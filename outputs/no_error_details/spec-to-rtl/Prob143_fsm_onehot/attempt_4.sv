module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);
    // S0:0, S1:1, S2:2, S3:3, S4:4, S5:5, S6:6, S7:7, S8:8, S9:9
    
    logic [9:0] ns;
    
    always @(*) begin
        ns = 10'b0;
        
        // S0-S4
        if (state[0]) ns |= (in ? 10'b0000000010 : 10'b0000000001);
        if (state[1]) ns |= (in ? 10'b0000000100 : 10'b0000000001);
        if (state[2]) ns |= (in ? 10'b0000001000 : 10'b0000000001);
        if (state[3]) ns |= (in ? 10'b0000010000 : 10'b0000000001);
        if (state[4]) ns |= (in ? 10'b0000100000 : 10'b0000000001);
        
        // S5: 1->S6(6), 0->S8(8)
        if (state[5]) ns |= (in ? 10'b0000000000 | (1 << 6) : 10'b0000000000 | (1 << 8));
        
        // S6: 1->S7(7), 0->S9(9)
        if (state[6]) ns |= (in ? 10'b0000000000 | (1 << 7) : 10'b0000000000 | (1 << 9));
        
        // S7: 1->S7, 0->S0
        if (state[7]) ns |= (in ? 10'b0000000000 | (1 << 7) : 10'b0000000000 | (1 << 0));
        
        // S8: 1->S1, 0->S0
        if (state[8]) ns |= (in ? 10'b0000000000 | (1 << 1) : 10'b0000000000 | (1 << 0));
        
        // S9: 1->S1, 0->S0
        if (state[9]) ns |= (in ? 10'b0000000000 | (1 << 1) : 10'b0000000000 | (1 << 0));
    end
    
    assign next_state = ns;
    
    // Output logic: S7 (0,1), S8 (1,0), S9 (1,1)
    assign out1 = state[8] || state[9];
    assign out2 = state[7] || state[9];

endmodule
