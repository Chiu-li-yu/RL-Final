module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    logic [9:0] next_s;
    logic o1, o2;

    assign next_state = next_s;
    assign out1 = o1;
    assign out2 = o2;

    always @(*) begin
        next_s = 10'b0;
        o1 = 1'b0;
        o2 = 1'b0;

        // Logic for next state transitions
        // S0: 0->S0, 1->S1
        if (state[0]) begin
            if (~in) next_s[0] = 1'b1;
            else next_s[1] = 1'b1;
        end
        // S1: 0->S0, 1->S2
        if (state[1]) begin
            if (~in) next_s[0] = 1'b1;
            else next_s[2] = 1'b1;
        end
        // S2: 0->S0, 1->S3
        if (state[2]) begin
            if (~in) next_s[0] = 1'b1;
            else next_s[3] = 1'b1;
        end
        // S3: 0->S0, 1->S4
        if (state[3]) begin
            if (~in) next_s[0] = 1'b1;
            else next_s[4] = 1'b1;
        end
        // S4: 0->S0, 1->S5
        if (state[4]) begin
            if (~in) next_s[0] = 1'b1;
            else next_s[5] = 1'b1;
        end
        // S5: 0->S8, 1->S6
        if (state[5]) begin
            if (~in) next_s[8] = 1'b1;
            else next_s[6] = 1'b1;
        end
        // S6: 0->S9, 1->S7
        if (state[6]) begin
            if (~in) next_s[9] = 1'b1;
            else next_s[7] = 1'b1;
        end
        // S7: 0->S0, 1->S7
        if (state[7]) begin
            if (~in) next_s[0] = 1'b1;
            else next_s[7] = 1'b1;
        end
        // S8: 0->S0, 1->S1
        if (state[8]) begin
            if (~in) next_s[0] = 1'b1;
            else next_s[1] = 1'b1;
        end
        // S9: 0->S0, 1->S1
        if (state[9]) begin
            if (~in) next_s[0] = 1'b1;
            else next_s[1] = 1'b1;
        end

        // Logic for output calculation
        // S7: (0, 1)
        // S8: (1, 0)
        // S9: (1, 1)
        if (state[7]) begin
            o2 = 1'b1;
        end
        if (state[8]) begin
            o1 = 1'b1;
        end
        if (state[9]) begin
            o1 = 1'b1;
            o2 = 1'b1;
        end
    end

endmodule
