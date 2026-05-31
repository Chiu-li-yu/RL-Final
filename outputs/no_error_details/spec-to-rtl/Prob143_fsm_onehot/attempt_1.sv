module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);
    logic [9:0] s;
    assign s = state;

    // Define next state transition logic for each state
    logic [9:0] next_s0, next_s1, next_s2, next_s3, next_s4, next_s5, next_s6, next_s7, next_s8, next_s9;

    always @(*) begin
        // Next state logic
        next_s0 = (in) ? 10'b0000000010 : 10'b0000000001; // S0: 1->S1, 0->S0
        next_s1 = (in) ? 10'b0000000100 : 10'b0000000001; // S1: 1->S2, 0->S0
        next_s2 = (in) ? 10'b0000001000 : 10'b0000000001; // S2: 1->S3, 0->S0
        next_s3 = (in) ? 10'b0000010000 : 10'b0000000001; // S3: 1->S4, 0->S0
        next_s4 = (in) ? 10'b0000100000 : 10'b0000000001; // S4: 1->S5, 0->S0
        next_s5 = (in) ? 10'b0001000000 : 10'b000100000000; // S5: 1->S6, 0->S8 (Wait, S8 is bit 8) -> 10'b0000000000? No, 10'b100000000 (S8)
        
        // Correcting index logic: S0=0, S1=1, ..., S8=8, S9=9
        // S5 --0--> S8, --1--> S6
        next_s5 = (in) ? 10'b0001000000 : 10'b0000000000; // Wait, indices 0-9
    end

    // Let's rewrite carefully
    // S0:0, S1:1, S2:2, S3:3, S4:4, S5:5, S6:6, S7:7, S8:8, S9:9
    always @(*) begin
        next_s0 = (in) ? 10'b0000000010 : 10'b0000000001;
        next_s1 = (in) ? 10'b0000000100 : 10'b0000000001;
        next_s2 = (in) ? 10'b0000001000 : 10'b0000000001;
        next_s3 = (in) ? 10'b0001000000 : 10'b0000000001; // Oh S3->S4. S4 is bit 4.
    end
endmodule
