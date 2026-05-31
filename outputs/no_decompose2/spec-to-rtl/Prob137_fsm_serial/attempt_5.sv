module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    localparam IDLE = 0, START = 1, D0 = 2, D1 = 3, D2 = 4, D3 = 5, D4 = 6, D5 = 7, D6 = 8, D7 = 9, STOP = 10;
    logic [3:0] state, next_state;
    logic done_q;

    always_ff @(posedge clk) begin
        if (reset) state <= IDLE;
        else       state <= next_state;
    end

    always_ff @(posedge clk) begin
        if (reset) done_q <= 1'b0;
        else       done_q <= (state == D7 && in == 1'b1); // Incorrect, need to capture at STOP
    end

    // Let's rethink. A protocol byte is 10 bits: Start(0) + 8 data + Stop(1)
    // The FSM needs to receive exactly 10 bits.
    
    // Maybe we need to count bits.
    logic [3:0] bit_cnt;
    always_ff @(posedge clk) begin
        if (reset) bit_cnt <= 0;
        else if (state == IDLE && in == 0) bit_cnt <= 0;
        else if (state >= START && state <= D7) bit_cnt <= bit_cnt + 1;
        else if (state == STOP) bit_cnt <= 0;
    end
    
    // Actually, simple state machine is better.
    // If we are in STOP and in == 1, then we are done.
    
    always @(*) begin
        case(state)
            IDLE: next_state = (in == 0) ? START : IDLE;
            START: next_state = D0;
            D0: next_state = D1;
            D1: next_state = D2;
            D2: next_state = D3;
            D3: next_state = D4;
            D4: next_state = D5;
            D5: next_state = D6;
            D6: next_state = D7;
            D7: next_state = STOP;
            STOP: next_state = (in == 1) ? IDLE : WAIT;
            WAIT: next_state = (in == 1) ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end
    
    assign done = (state == STOP && in == 1);

endmodule
