module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    localparam IDLE  = 4'd0,
               START = 4'd1,
               D0    = 4'd2,
               D1    = 4'd3,
               D2    = 4'd4,
               D3    = 4'd5,
               D4    = 4'd6,
               D5    = 4'd7,
               D6    = 4'd8,
               D7    = 4'd9,
               STOP  = 4'd10,
               DONE_ST = 4'd11,
               WAIT  = 4'd12;

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

    // The output "done" should be high when the stop bit is received.
    // If we transition to DONE_ST when a STOP bit is received, 
    // maybe it should be assigned in the STOP state itself.
    assign done = (state == STOP && in == 1'b1);

endmodule
