module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);
    // State bits: S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7, S8=8, S9=9
    
    // next_state logic
    // From S0: S0 if 0, S1 if 1
    // From S1: S0 if 0, S2 if 1
    // From S2: S0 if 0, S3 if 1
    // From S3: S0 if 0, S4 if 1
    // From S4: S0 if 0, S5 if 1
    // From S5: S8 if 0, S6 if 1
    // From S6: S9 if 0, S7 if 1
    // From S7: S0 if 0, S7 if 1
    // From S8: S0 if 0, S1 if 1
    // From S9: S0 if 0, S1 if 1

    logic [9:0] next_s;

    always @(*) begin
        next_s = 10'b0;
        
        // S0 transitions
        if (state[0]) begin
            if (~in) next_s[0] = 1'b1;
            else     next_s[1] = 1'b1;
        end
        // S1 transitions
        if (state[1]) begin
            if (~in) next_s[0] = 1'b1;
            else     next_s[2] = 1'b1;
        end
        // S2 transitions
        if (state[2]) begin
            if (~in) next_s[0] = 1'b1;
            else     next_s[3] = 1'b1;
        end
        // S3 transitions
        if (state[3]) begin
            if (~in) next_s[0] = 1'b1;
            else     next_s[4] = 1'b1;
        end
        // S4 transitions
        if (state[4]) begin
            if (~in) next_s[0] = 1'b1;
            else     next_s[5] = 1'b1;
        end
        // S5 transitions
        if (state[5]) begin
            if (~in) next_s[8] = 1'b1;
            else     next_s[6] = 1'b1;
        end
        // S6 transitions
        if (state[6]) begin
            if (~in) next_s[9] = 1'b1;
            else     next_s[7] = 1'b1;
        end
        // S7 transitions
        if (state[7]) begin
            if (~in) next_s[0] = 1'b1;
            else     next_s[7] = 1'b1;
        end
        // S8 transitions
        if (state[8]) begin
            if (~in) next_s[0] = 1'b1;
            else     next_s[1] = 1'b1;
        end
        // S9 transitions
        if (state[9]) begin
            if (~in) next_s[0] = 1'b1;
            else     next_s[1] = 1'b1;
        end
    end

    assign next_state = next_s;

    // Output logic
    // S7: (0, 1)
    // S8: (1, 0)
    // S9: (1, 1)
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule
