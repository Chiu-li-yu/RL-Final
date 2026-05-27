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
        WAIT
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_cnt <= 3'b0;
            done <= 1'b0;
            out_byte <= 8'b0;
        end else begin
            state <= next_state;
            case (next_state)
                IDLE: done <= 1'b0;
                DATA: begin
                    if (state == START) begin
                        bit_cnt <= 3'b0;
                    end else begin
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_cnt <= bit_cnt + 1'b1;
                    end
                end
                STOP: begin
                    done <= (in == 1'b1);
                    out_byte <= {in, shift_reg[7:1]};
                end
                WAIT: done <= 1'b0;
                default: done <= 1'b0;
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) next_state = DATA;
            end
            DATA: begin
                if (bit_cnt == 3'b111) next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1) next_state = IDLE;
                else next_state = WAIT;
            end
            WAIT: begin
                if (in == 1'b1) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
