module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);
    logic [9:0] ns;
    assign next_state = ns;

    always @(*) begin
        ns = 10'b0;
        // Logic for transitions
        // If state[0] (S0)
        if (state[0]) begin
            if (in) ns[1] = 1'b1; else ns[0] = 1'b1;
        end
        // If state[1] (S1)
        if (state[1]) begin
            if (in) ns[2] = 1'b1; else ns[0] = 1'b1;
        end
        // If state[2] (S2)
        if (state[2]) begin
            if (in) ns[3] = 1'b1; else ns[0] = 1'b1;
        end
        // If state[3] (S3)
        if (state[3]) begin
            if (in) ns[4] = 1'b1; else ns[0] = 1'b1;
        end
        // If state[4] (S4)
        if (state[4]) begin
            if (in) ns[5] = 1'b1; else ns[0] = 1'b1;
        end
        // If state[5] (S5)
        if (state[5]) begin
            if (in) ns[6] = 1'b1; else ns[8] = 1'b1;
        end
        // If state[6] (S6)
        if (state[6]) begin
            if (in) ns[7] = 1'b1; else ns[9] = 1'b1;
        end
        // If state[7] (S7)
        if (state[7]) begin
            if (in) ns[7] = 1'b1; else ns[0] = 1'b1;
        end
        // If state[8] (S8)
        if (state[8]) begin
            if (in) ns[1] = 1'b1; else ns[0] = 1'b1;
        end
        // If state[9] (S9)
        if (state[9]) begin
            if (in) ns[1] = 1'b1; else ns[0] = 1'b1;
        end
    end

    // Output logic
    // out1: S8, S9
    assign out1 = state[8] | state[9];
    // out2: S7, S9
    assign out2 = state[7] | state[9];

endmodule
