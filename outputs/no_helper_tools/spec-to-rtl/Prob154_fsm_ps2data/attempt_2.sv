module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2,
        DONE_ST = 2'd3
    } state_t;

    state_t state, next_state;
    logic [7:0] b1, b2, b3;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            b1 <= 8'd0;
            b2 <= 8'd0;
            b3 <= 8'd0;
        end else begin
            state <= next_state;
            if (state == IDLE && in[3]) b1 <= in;
            else if (state == BYTE2) b2 <= in;
            else if (state == BYTE3) b3 <= in;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = (in[3]) ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = DONE_ST;
            DONE_ST: next_state = (in[3]) ? BYTE2 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        done = (state == DONE_ST);
        out_bytes = {b1, b2, b3};
    end

endmodule
