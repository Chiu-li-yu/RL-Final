module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    logic [1:0] state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    parameter IDLE = 2'd0;
    parameter START = 2'd1;
    parameter DATA = 2'd2;
    parameter STOP = 2'd3;

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
                IDLE: begin
                    done <= 1'b0;
                end
                DATA: begin
                    if (state == START) bit_cnt <= 3'd0;
                    else if (state == DATA) begin
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_cnt <= bit_cnt + 1'd1;
                    end
                end
                STOP: begin
                    if (bit_cnt == 3'd7 && state == DATA) begin
                        shift_reg <= {in, shift_reg[7:1]};
                        out_byte <= {in, shift_reg[7:1]};
                        done <= 1'b1;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE:  next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA;
            DATA:  next_state = (bit_cnt == 3'd7) ? STOP : DATA;
            STOP:  next_state = (in == 1'b1) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

endmodule
