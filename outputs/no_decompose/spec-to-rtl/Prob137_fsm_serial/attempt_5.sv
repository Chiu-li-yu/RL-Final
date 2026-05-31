module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    localparam IDLE = 0, START = 1, D0 = 2, D1 = 3, D2 = 4, D3 = 5, D4 = 6, D5 = 7, D6 = 8, D7 = 9, STOP = 10, WAIT = 11;
    logic [3:0] state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE: next_state = (in == 0) ? START : IDLE;
            START: next_state = D0;
            D0: next_state = D1;
            D1: next_state = D2;
            D2: next_state = D3;
            D3: next_state = D4;
            D4: next_state = D5;
            D5: next_state = D6;
            D6: next_state = D7;
            D7: next_state = (in == 1) ? IDLE : WAIT;
            WAIT: next_state = (in == 1) ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end

    assign done = (state == STOP);

endmodule
