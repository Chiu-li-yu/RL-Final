module TopModule (
    input clk,
    input reset,
    input w,
    output Y1,
    output Y3
);
    logic [5:0] state;

    always_ff @(posedge clk) begin
        if (reset)
            state <= 6'b000001;
        else begin
            logic [5:0] next_state;
            next_state = 6'b000000;
            case (1'b1)
                state[0]: next_state = w ? 6'b000001 : 6'b000010;
                state[1]: next_state = w ? 6'b001000 : 6'b000100;
                state[2]: next_state = w ? 6'b001000 : 6'b010000;
                state[3]: next_state = w ? 6'b000001 : 6'b100000;
                state[4]: next_state = w ? 6'b001000 : 6'b010000;
                state[5]: next_state = w ? 6'b001000 : 6'b000100;
            endcase
            state <= next_state;
        end
    end

    // Y1 is the next state of B (which is state[1])
    // Y3 is the next state of D (which is state[3])
    // From transitions:
    // next B (Y1) = state[0] & ~w
    // next D (Y3) = (state[1] & w) | (state[2] & w) | (state[4] & w) | (state[5] & w)
    assign Y1 = state[0] & ~w;
    assign Y3 = (state[1] | state[2] | state[4] | state[5]) & w;

endmodule
