module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);
    logic [9:0] next_state_internal;
    logic out1_internal, out2_internal;

    assign next_state = next_state_internal;
    assign out1 = out1_internal;
    assign out2 = out2_internal;

    always @(*) begin
        next_state_internal = 10'b0;
        out1_internal = 1'b0;
        out2_internal = 1'b0;

        // State S0 (state[0])
        if (state[0]) begin
            if (in) next_state_internal[1] = 1'b1;
            else    next_state_internal[0] = 1'b1;
        end
        // State S1 (state[1])
        if (state[1]) begin
            if (in) next_state_internal[2] = 1'b1;
            else    next_state_internal[0] = 1'b1;
        end
        // State S2 (state[2])
        if (state[2]) begin
            if (in) next_state_internal[3] = 1'b1;
            else    next_state_internal[0] = 1'b1;
        end
        // State S3 (state[3])
        if (state[3]) begin
            if (in) next_state_internal[4] = 1'b1;
            else    next_state_internal[0] = 1'b1;
        end
        // State S4 (state[4])
        if (state[4]) begin
            if (in) next_state_internal[5] = 1'b1;
            else    next_state_internal[0] = 1'b1;
        end
        // State S5 (state[5])
        if (state[5]) begin
            if (in) next_state_internal[6] = 1'b1;
            else    next_state_internal[8] = 1'b1;
        end
        // State S6 (state[6])
        if (state[6]) begin
            if (in) next_state_internal[7] = 1'b1;
            else    next_state_internal[9] = 1'b1;
        end
        // State S7 (state[7])
        if (state[7]) begin
            out2_internal = 1'b1;
            if (in) next_state_internal[7] = 1'b1;
            else    next_state_internal[0] = 1'b1;
        end
        // State S8 (state[8])
        if (state[8]) begin
            out1_internal = 1'b1;
            if (in) next_state_internal[1] = 1'b1;
            else    next_state_internal[0] = 1'b1;
        end
        // State S9 (state[9])
        if (state[9]) begin
            out1_internal = 1'b1;
            out2_internal = 1'b1;
            if (in) next_state_internal[1] = 1'b1;
            else    next_state_internal[0] = 1'b1;
        end
    end
endmodule
