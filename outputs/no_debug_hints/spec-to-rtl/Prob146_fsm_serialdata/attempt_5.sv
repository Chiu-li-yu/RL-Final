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
        WAIT_STOP
    } state_t;

    state_t state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'b0;
            done <= 1'b0;
            shift_reg <= 8'b0;
            bit_cnt <= 3'b0;
        end else begin
            done <= 1'b0;
            case (state)
                IDLE: begin
                    if (in == 1'b0) state <= DATA; 
                    bit_cnt <= 3'b0;
                end
                DATA: begin
                    shift_reg[bit_cnt] <= in;
                    if (bit_cnt == 3'd7) state <= STOP;
                    else bit_cnt <= bit_cnt + 1'b1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
                    end
                end
                WAIT_STOP: begin
                    if (in == 1'b1) state <= IDLE;
                end
            endcase
        end
    end
endmodule