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
        BYTE3 = 2'b10
    } state_t;

    state_t state, next_state;
    logic [7:0] b1, b2, b3;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            b1 <= 8'h0;
            b2 <= 8'h0;
            b3 <= 8'h0;
        end else begin
            state <= next_state;
            if (state == IDLE && in[3]) begin
                b1 <= in;
            end else if (state == BYTE2) begin
                b2 <= in;
            end else if (state == BYTE3) begin
                b3 <= in;
            end
        end
    end

    always @(*) begin
        next_state = state;
        done = 1'b0;
        out_bytes = {b1, b2, b3};

        case (state)
            IDLE: begin
                if (in[3]) next_state = BYTE2;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                done = 1'b1;
                next_state = IDLE;
                // Wait for a new byte with bit 3 set to restart
                if (in[3]) next_state = BYTE2;
            end
        endcase
    end
endmodule
