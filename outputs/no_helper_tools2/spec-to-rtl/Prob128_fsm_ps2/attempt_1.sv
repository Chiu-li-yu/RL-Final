module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    typedef enum logic [1:0] {
        STATE_BYTE1 = 2'd0,
        STATE_BYTE2 = 2'd1,
        STATE_BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;
    logic done_q;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_BYTE1;
            done_q <= 1'b0;
        end else begin
            state <= next_state;
            done_q <= (next_state == STATE_BYTE1 && state == STATE_BYTE3);
        end
    end

    always @(*) begin
        case (state)
            STATE_BYTE1: begin
                if (in[3])
                    next_state = STATE_BYTE2;
                else
                    next_state = STATE_BYTE1;
            end
            STATE_BYTE2: begin
                next_state = STATE_BYTE3;
            end
            STATE_BYTE3: begin
                next_state = STATE_BYTE1;
            end
            default: next_state = STATE_BYTE1;
        endcase
    end

    assign done = done_q;

endmodule
