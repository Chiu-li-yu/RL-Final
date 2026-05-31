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
    logic [7:0] byte1, byte2, byte3;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_WAIT_BYTE1;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
        end else begin
            state <= next_state;
            if (state == STATE_WAIT_BYTE1 && in[3]) begin
                byte1 <= in;
            end else if (state == STATE_WAIT_BYTE2) begin
                byte2 <= in;
            end else if (state == STATE_WAIT_BYTE3) begin
                byte3 <= in;
            end
        end
    end

    always @(*) begin
        next_state = state;
        done = 1'b0;
        out_bytes = 24'd0;

        case (state)
            STATE_WAIT_BYTE1: begin
                if (in[3]) next_state = STATE_WAIT_BYTE2;
            end
            STATE_WAIT_BYTE2: begin
                next_state = STATE_WAIT_BYTE3;
            end
            STATE_WAIT_BYTE3: begin
                next_state = STATE_DONE;
            end
            STATE_DONE: begin
                done = 1'b1;
                out_bytes = {byte1, byte2, byte3};
                if (in[3]) next_state = STATE_WAIT_BYTE2;
                else next_state = STATE_WAIT_BYTE1;
            end
        endcase
    end
endmodule
