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
        STOP
    } state_t;

    state_t state, next_state;
    logic [2:0] bit_cnt;
    logic [7:0] shift_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            state <= next_state;
            
            if (state == START) begin
                shift_reg <= 8'd0;
                bit_cnt <= 3'd0;
                done <= 1'b0;
            end else if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 3'd1;
            end else if (state == STOP && in == 1'b1) begin
                out_byte <= shift_reg;
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
