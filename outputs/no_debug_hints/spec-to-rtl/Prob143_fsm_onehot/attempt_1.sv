module TopModule (
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    logic [9:0] nxt;
    logic o1, o2;

    always @(*) begin
        nxt = 10'b0;
        o1 = 1'b0;
        o2 = 1'b0;

        // Transition Logic (One-hot decoding)
        // S0: state[0] --0--> S0; --1--> S1
        if (state[0]) begin
            if (~in) nxt[0] = 1'b1;
            else     nxt[1] = 1'b1;
        end
        // S1: state[1] --0--> S0; --1--> S2
        if (state[1]) begin
            if (~in) nxt[0] = 1'b1;
            else     nxt[2] = 1'b1;
        end
        // S2: state[2] --0--> S0; --1--> S3
        if (state[2]) begin
            if (~in) nxt[0] = 1'b1;
            else     nxt[3] = 1'b1;
        end
        // S3: state[3] --0--> S0; --1--> S4
        if (state[3]) begin
            if (~in) nxt[0] = 1'b1;
            else     nxt[4] = 1'b1;
        end
        // S4: state[4] --0--> S0; --1--> S5
        if (state[4]) begin
            if (~in) nxt[0] = 1'b1;
            else     nxt[5] = 1'b1;
        end
        // S5: state[5] --0--> S8; --1--> S6
        if (state[5]) begin
            if (~in) nxt[8] = 1'b1;
            else     nxt[6] = 1'b1;
        end
        // S6: state[6] --0--> S9; --1--> S7
        if (state[6]) begin
            if (~in) nxt[9] = 1'b1;
            else     nxt[7] = 1'b1;
        end
        // S7: state[7] --0--> S0; --1--> S7 (out: 0,1)
        if (state[7]) begin
            if (~in) nxt[0] = 1'b1;
            else     nxt[7] = 1'b1;
            o2 = 1'b1;
        end
        // S8: state[8] --0--> S0; --1--> S1 (out: 1,0)
        if (state[8]) begin
            if (~in) nxt[0] = 1'b1;
            else     nxt[1] = 1'b1;
            o1 = 1'b1;
        end
        // S9: state[9] --0--> S0; --1--> S1 (out: 1,1)
        if (state[9]) begin
            if (~in) nxt[0] = 1'b1;
            else     nxt[1] = 1'b1;
            o1 = 1'b1;
            o2 = 1'b1;
        end
    end

    assign next_state = nxt;
    assign out1 = o1;
    assign out2 = o2;

endmodule
