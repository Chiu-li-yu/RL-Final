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
        STATE_DONE       = 2'd3
    } state_t;

    state_t state, next_state;
    logic [7:0] b1, b2, b3;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_WAIT_BYTE1;
            b1 <= 8'd0;
            b2 <= 8'd0;
            b3 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == STATE_WAIT_BYTE1 && in[3]) b1 <= in;
            if (state == STATE_WAIT_BYTE2) b2 <= in;
            if (state == STATE_WAIT_BYTE3) b3 <= in;
            if (next_state == STATE_DONE) begin
                out_bytes <= {b1, b2, in};
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always_comb begin
        case (state)
            STATE_WAIT_BYTE1:
                if (in[3]) next_state = STATE_WAIT_BYTE2;
                else next_state = STATE_WAIT_BYTE1;
            STATE_WAIT_BYTE2:
                next_state = STATE_WAIT_BYTE3;
            STATE_WAIT_BYTE3:
                next_state = STATE_DONE;
            STATE_DONE:
                if (in[3]) next_state = STATE_WAIT_BYTE2;
                else next_state = STATE_WAIT_BYTE1;
            default: next_state = STATE_WAIT_BYTE1;
        endcase
    end
endmodule
