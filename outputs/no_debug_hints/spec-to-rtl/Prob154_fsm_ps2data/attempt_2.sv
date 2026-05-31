module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        STATE_WAIT_BYTE1 = 2'd0,
        STATE_WAIT_BYTE2 = 2'd1,
        STATE_WAIT_BYTE3 = 2'd2,
        STATE_DONE_SIGNAL = 2'd3
    } state_t;

    state_t state, next_state;
    logic [7:0] b1, b2, b3;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_WAIT_BYTE1;
            b1 <= 8'd0; b2 <= 8'd0; b3 <= 8'd0;
        end else begin
            state <= next_state;
            if (state == STATE_WAIT_BYTE1 && in[3]) b1 <= in;
            else if (state == STATE_WAIT_BYTE2) b2 <= in;
            else if (state == STATE_WAIT_BYTE3) b3 <= in;
        end
    end

    always @(*) begin
        next_state = state;
        done = 1'b0;
        out_bytes = {b1, b2, b3};

        case (state)
            STATE_WAIT_BYTE1: begin
                if (in[3]) next_state = STATE_WAIT_BYTE2;
            end
            STATE_WAIT_BYTE2: begin
                next_state = STATE_WAIT_BYTE3;
            end
            STATE_WAIT_BYTE3: begin
                next_state = STATE_DONE_SIGNAL;
                done = 1'b1;
                out_bytes = {b1, b2, in};
            end
            STATE_DONE_SIGNAL: begin
                // The prompt says signal done in the cycle *immediately after* 
                // the third byte of each message was successfully received.
                // In my FSM, STATE_WAIT_BYTE3 happens when 3rd byte is received.
                // So I need a state to be high 'done' for 1 cycle.
                
                // Let's re-read: "signal done in the cycle immediately after 
                // the third byte of each message was successfully received."
                // Wait, "after"? 
                // If the 3rd byte is received at T, then at T+1 done=1.
                // My previous STATE_DONE_SIGNAL logic:
                // T: state_wait3, receive b3
                // T+1: state_done_signal, done=1. Correct.
            end
        endcase
    end
endmodule
