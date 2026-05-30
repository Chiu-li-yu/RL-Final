module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);
    localparam IDLE = 2'b00, DATA = 2'b01, STOP = 2'b10;
    logic [1:0] state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always @(*) begin
        case (state)
            IDLE: next_state = (in == 0) ? DATA : IDLE;
            DATA: next_state = (bit_cnt == 7) ? STOP : DATA;
            STOP: next_state = (in == 1) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            shift_reg <= 0;
            bit_cnt <= 0;
        end else begin
            state <= next_state;
            case (next_state)
                IDLE: begin
                    done <= 0;
                    bit_cnt <= 0;
                end
                DATA: begin
                    if (state == IDLE) begin
                        bit_cnt <= 0;
                    end else begin
                        shift_reg <= {in, shift_reg[7:1]};
                        bit_cnt <= bit_cnt + 1;
                    end
                    done <= 0;
                end
                STOP: begin
                    if (state == DATA) begin
                        // last bit already shifted in
                    end
                    if (in == 1) begin
                        out_byte <= shift_reg;
                        done <= 1;
                    end else begin
                        done <= 0;
                    end
                end
            endcase
        end
    end
endmodule
