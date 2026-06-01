module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output logic done
);
    typedef enum logic [1:0] {
        STATE_WAIT = 2'd0,
        STATE_BYTE2 = 2'd1,
        STATE_BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_WAIT;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        done = 1'b0;

        case (state)
            STATE_WAIT: begin
                if (in[3]) begin
                    next_state = STATE_BYTE2;
                end
            end
            STATE_BYTE2: begin
                next_state = STATE_BYTE3;
            end
            STATE_BYTE3: begin
                done = 1'b1;
                if (in[3]) begin
                    next_state = STATE_BYTE2;
                end else begin
                    next_state = STATE_WAIT;
                end
            end
        endcase
    end
endmodule
