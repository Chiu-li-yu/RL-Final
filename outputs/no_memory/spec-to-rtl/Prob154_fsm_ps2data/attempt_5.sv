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
        DONE_ST = 2'b11
    } state_t;

    state_t state, next_state;
    logic [23:0] shift_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 24'b0;
            done <= 1'b0;
            out_bytes <= 24'b0;
        end else begin
            state <= next_state;
            if (state == IDLE && in[3]) begin
                shift_reg[23:16] <= in;
            end else if (state == BYTE2) begin
                shift_reg[15:8] <= in;
            end else if (state == BYTE3) begin
                shift_reg[7:0] <= in;
            end

            if (next_state == DONE_ST) begin
                done <= 1'b1;
                out_bytes <= (state == BYTE3) ? {shift_reg[23:8], in} : 24'b0;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = (in[3]) ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = DONE_ST;
            DONE_ST: next_state = (in[3]) ? BYTE2 : IDLE;
        endcase
    end
endmodule
