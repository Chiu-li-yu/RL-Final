module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE  = 2'd0,
        DATA  = 2'd1,
        STOP  = 2'd2
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (!in) next_state = DATA;
            DATA: if (bit_cnt == 3'd7) next_state = STOP;
            STOP: if (in) next_state = IDLE;
                  else next_state = STOP;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'd0;
            bit_cnt <= 3'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    bit_cnt <= 3'd0;
                end
                DATA: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                    done <= 1'b0;
                end
                STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end else begin
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end
endmodule
