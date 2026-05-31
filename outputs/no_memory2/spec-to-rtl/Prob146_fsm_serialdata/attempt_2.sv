module TopModule (
    input  clk,
    input  in,
    input  reset,
    output logic [7:0] out_byte,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        DATA = 2'b01,
        WAIT_STOP = 2'b10
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 0)
                    next_state = DATA;
            end
            DATA: begin
                if (bit_cnt == 7)
                    next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 0;
            shift_reg <= 0;
            done <= 0;
            out_byte <= 0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    done <= 0;
                    bit_cnt <= 0;
                end
                DATA: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 7) begin
                        // Prepare for next cycle
                    end
                end
                WAIT_STOP: begin
                    if (in == 1) begin
                        done <= 1;
                        out_byte <= shift_reg;
                    end
                end
            endcase
        end
    end
endmodule