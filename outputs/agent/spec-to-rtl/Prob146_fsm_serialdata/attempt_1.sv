module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    typedef enum logic [2:0] {
        IDLE  = 3'd0,
        START = 3'd1,
        DATA  = 3'd2,
        STOP  = 3'd3
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'd0;
            bit_cnt <= 3'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 1'b1;
            end else if (state == STOP) begin
                if (in) begin
                    out_byte <= shift_reg;
                    done <= 1'b1;
                end else begin
                    done <= 1'b0;
                end
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:  if (!in) next_state = DATA;
            DATA:  if (bit_cnt == 3'd7) next_state = STOP;
            STOP:  if (in) next_state = IDLE; else next_state = STOP;
            default: next_state = IDLE;
        endcase
    end

endmodule
