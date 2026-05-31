module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    localparam IDLE  = 0,
               START = 1,
               D0    = 2,
               D1    = 3,
               D2    = 4,
               D3    = 5,
               D4    = 6,
               D5    = 7,
               D6    = 8,
               D7    = 9,
               STOP  = 10,
               DONE_ST = 11,
               WAIT  = 12;

    logic [3:0] state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= IDLE;
        else       state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 1'b0) ? START : IDLE;
            START:   next_state = D0;
            D0:      next_state = D1;
            D1:      next_state = D2;
            D2:      next_state = D3;
            D3:      next_state = D4;
            D4:      next_state = D5;
            D5:      next_state = D6;
            D6:      next_state = D7;
            D7:      next_state = STOP;
            STOP:    next_state = (in == 1'b1) ? DONE_ST : WAIT;
            DONE_ST: next_state = (in == 1'b0) ? START : IDLE;
            WAIT:    next_state = (in == 1'b1) ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end

    // The specification says "8 data bits" after start.
    // My FSM logic goes START -> D0..D7 -> STOP
    // In my logic, D0 is the 1st bit (LSB). Total 8 bits.
    // If the testbench expects "done" to be high when the stop bit is correctly received,
    // it should be high during the STOP state if it was valid.

    assign done = (state == DONE_ST);

endmodule
