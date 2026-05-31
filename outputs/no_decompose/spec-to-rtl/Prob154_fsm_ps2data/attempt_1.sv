module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BYTE2 = 2'b01,
        BYTE3 = 2'b10,
        DONE_STATE = 2'b11
    } state_t;

    state_t state, next_state;
    logic [7:0] b1, b2, b3;
    logic [7:0] next_b1, next_b2, next_b3;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            b1 <= 8'd0;
            b2 <= 8'd0;
            b3 <= 8'd0;
        end else begin
            state <= next_state;
            b1 <= next_b1;
            b2 <= next_b2;
            b3 <= next_b3;
        end
    end

    always @(*) begin
        next_state = state;
        next_b1 = b1;
        next_b2 = b2;
        next_b3 = b3;
        done = 1'b0;
        out_bytes = 24'd0;

        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_b1 = in;
                    next_state = BYTE2;
                end
            end
            BYTE2: begin
                next_b2 = in;
                next_state = BYTE3;
            end
            BYTE3: begin
                next_b3 = in;
                next_state = DONE_STATE;
            end
            DONE_STATE: begin
                done = 1'b1;
                out_bytes = {b1, b2, b3};
                // Transition logic: either back to IDLE or start new
                if (in[3]) begin
                    next_b1 = in;
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule
