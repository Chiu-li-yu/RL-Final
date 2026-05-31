module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);
    // Transition logic
    // S0: 0, S1: 1, S2: 2, S3: 3, S4: 4, S5: 5, S6: 6, S7: 7, S8: 8, S9: 9
    
    logic [9:0] ns [9:0];
    
    always @(*) begin
        ns[0] = (in) ? 10'b0000000010 : 10'b0000000001; // S0 -> S1/S0
        ns[1] = (in) ? 10'b0000000100 : 10'b0000000001; // S1 -> S2/S0
        ns[2] = (in) ? 10'b0000001000 : 10'b0000000001; // S2 -> S3/S0
        ns[3] = (in) ? 10'b0001000000 : 10'b0000000001; // S3 -> S4/S0 (Wait, S4 is index 4, fixed)
        ns[3] = (in) ? 10'b0000010000 : 10'b0000000001; // S3 -> S4/S0
        ns[4] = (in) ? 10'b0010000000 : 10'b0000000001; // S4 -> S5/S0 (Wait, S5 is index 5)
        ns[4] = (in) ? 10'b0000100000 : 10'b0000000001; // S4 -> S5/S0
        ns[5] = (in) ? 10'b0100000000 : 10'b0000000000; // S5 -> S6/S8? (S6=6, S8=8)
        // Let's restart logic indexing carefully
    end
endmodule
