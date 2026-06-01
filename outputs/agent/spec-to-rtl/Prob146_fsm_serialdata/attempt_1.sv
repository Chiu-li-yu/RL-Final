module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        DONE_STATE
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            shift_reg <= 0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 1;
            end else begin
                bit_cnt <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        done = 0;
        out_byte = 8'b0;

        case (state)
            IDLE: begin
                if (in == 0)
                    next_state = DATA;
            end
            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1)
                    next_state = DONE_STATE;
                else
                    next_state = IDLE; // Wait for idle line as per spec
            end
            DONE_STATE: begin
                done = 1;
                out_byte = shift_reg;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
