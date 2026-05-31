module TopModule (
    input logic in,
    input logic [9:0] state,
    output logic [9:0] next_state,
    output logic out1,
    output logic out2
);

    logic [9:0] s;
    assign s = state;

    always @(*) begin
        next_state = 10'b0;
        
        // Next State Logic
        // S0: 0->S0, 1->S1
        if (s[0]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[1] = 1'b1;
        end
        // S1: 0->S0, 1->S2
        if (s[1]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[2] = 1'b1;
        end
        // S2: 0->S0, 1->S3
        if (s[2]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[3] = 1'b1;
        end
        // S3: 0->S0, 1->S4
        if (s[3]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[4] = 1'b1;
        end
        // S4: 0->S0, 1->S5
        if (s[4]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[5] = 1'b1;
        end
        // S5: 0->S8, 1->S6
        if (s[5]) begin
            if (~in) next_state[8] = 1'b1;
            else     next_state[6] = 1'b1;
        end
        // S6: 0->S9, 1->S7
        if (s[6]) begin
            if (~in) next_state[9] = 1'b1;
            else     next_state[7] = 1'b1;
        end
        // S7: 0->S0, 1->S7
        if (s[7]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[7] = 1'b1;
        end
        // S8: 0->S0, 1->S1
        if (s[8]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[1] = 1'b1;
        end
        // S9: 0->S0, 1->S1
        if (s[9]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[1] = 1'b1;
        end

        // Output Logic
        out1 = (s[8] & ~in) | (s[9] & ~in);
        out2 = (s[7] & ~in) | (s[9] & ~in);
    end

endmodule
