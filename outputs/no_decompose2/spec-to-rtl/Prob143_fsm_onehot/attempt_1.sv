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

        // Transition Logic
        if (state[0]) begin
            if (in) next_s[1] = 1'b1; else next_s[0] = 1'b1;
        end
        if (state[1]) begin
            if (in) next_s[2] = 1'b1; else next_s[0] = 1'b1;
        end
        if (state[2]) begin
            if (in) next_s[3] = 1'b1; else next_s[0] = 1'b1;
        end
        if (state[3]) begin
            if (in) next_s[4] = 1'b1; else next_s[0] = 1'b1;
        end
        if (state[4]) begin
            if (in) next_s[5] = 1'b1; else next_s[0] = 1'b1;
        end
        if (state[5]) begin
            if (in) next_s[6] = 1'b1; else next_s[8] = 1'b1;
        end
        if (state[6]) begin
            if (in) next_s[7] = 1'b1; else next_s[9] = 1'b1;
        end
        if (state[7]) begin
            if (in) next_s[7] = 1'b1; else next_s[0] = 1'b1;
        end
        if (state[8]) begin
            if (in) next_s[1] = 1'b1; else next_s[0] = 1'b1;
        end
        if (state[9]) begin
            if (in) next_s[1] = 1'b1; else next_s[0] = 1'b1;
        end

        // Output Logic
        if (state[8]) o1 = 1'b1;
        if (state[9]) begin
            o1 = 1'b1;
            o2 = 1'b1;
        end
        if (state[7]) o2 = 1'b1;
    end
endmodule
