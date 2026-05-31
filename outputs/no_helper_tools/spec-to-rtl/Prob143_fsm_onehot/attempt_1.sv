module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);
    logic [9:0] next_state_logic;
    logic out1_logic, out2_logic;

    assign next_state = next_state_logic;
    assign out1 = out1_logic;
    assign out2 = out2_logic;

    always @(*) begin
        next_state_logic = 10'b0;
        out1_logic = 0;
        out2_logic = 0;

        // Transition logic
        if (state[0]) begin // S0
            if (in) next_state_logic[1] = 1; else next_state_logic[0] = 1;
        end
        if (state[1]) begin // S1
            if (in) next_state_logic[2] = 1; else next_state_logic[0] = 1;
        end
        if (state[2]) begin // S2
            if (in) next_state_logic[3] = 1; else next_state_logic[0] = 1;
        end
        if (state[3]) begin // S3
            if (in) next_state_logic[4] = 1; else next_state_logic[0] = 1;
        end
        if (state[4]) begin // S4
            if (in) next_state_logic[5] = 1; else next_state_logic[0] = 1;
        end
        if (state[5]) begin // S5
            if (in) next_state_logic[6] = 1; else next_state_logic[8] = 1;
        end
        if (state[6]) begin // S6
            if (in) next_state_logic[7] = 1; else next_state_logic[9] = 1;
        end
        if (state[7]) begin // S7
            if (in) next_state_logic[7] = 1; else next_state_logic[0] = 1;
        end
        if (state[8]) begin // S8
            if (in) next_state_logic[1] = 1; else next_state_logic[0] = 1;
        end
        if (state[9]) begin // S9
            if (in) next_state_logic[1] = 1; else next_state_logic[0] = 1;
        end

        // Output logic
        if (state[7]) begin out1_logic = 0; out2_logic = 1; end
        if (state[8]) begin out1_logic = 1; out2_logic = 0; end
        if (state[9]) begin out1_logic = 1; out2_logic = 1; end
    end
endmodule
