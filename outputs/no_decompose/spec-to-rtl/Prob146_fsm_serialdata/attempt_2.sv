module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        START = 2'd1,
        DATA = 2'd2,
        STOP = 2'd3
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
            
            case (state)
                IDLE: begin
                    done <= 1'b0;
                end
                DATA: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end
            endcase
            
            if (next_state == DATA && state == START) begin
                bit_cnt <= 3'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:  next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA;
            DATA:  next_state = (bit_cnt == 3'd7) ? STOP : DATA;
            STOP:  next_state = (in == 1'b1) ? IDLE : STOP;
        endcase
    end

endmodule
