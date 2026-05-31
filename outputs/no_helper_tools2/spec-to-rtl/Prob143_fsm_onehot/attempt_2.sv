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
        if (s[0]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[1] = 1'b1;
        end
        if (s[1]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[2] = 1'b1;
        end
        if (s[2]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[3] = 1'b1;
        end
        if (s[3]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[4] = 1'b1;
        end
        if (s[4]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[5] = 1'b1;
        end
        if (s[5]) begin
            if (~in) next_state[8] = 1'b1;
            else     next_state[6] = 1'b1;
        end
        if (s[6]) begin
            if (~in) next_state[9] = 1'b1;
            else     next_state[7] = 1'b1;
        end
        if (s[7]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[7] = 1'b1;
        end
        if (s[8]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[1] = 1'b1;
        end
        if (s[9]) begin
            if (~in) next_state[0] = 1'b1;
            else     next_state[1] = 1'b1;
        end

        // Output Logic
        // S7: (0, 1), S8: (1, 0), S9: (1, 1)
        out1 = s[8] | s[9];
        out2 = s[7] | s[9];
    end

endmodule
