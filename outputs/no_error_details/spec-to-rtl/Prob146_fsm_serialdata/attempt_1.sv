module TopModule (
    input logic clk,
    input logic in,
    input logic reset,
    output logic [7:0] out_byte,
    output logic done
);
    typedef enum logic [2:0] {
        IDLE,
        START,
        RECEIVE,
        STOP,
        FINISH
    } state_t;

    state_t state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_cnt <= 3'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == RECEIVE) begin
                shift_reg[bit_cnt] <= in;
                bit_cnt <= bit_cnt + 1'b1;
            end else if (state == IDLE) begin
                bit_cnt <= 3'b0;
            end
            
            if (next_state == FINISH) begin
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
                if (in == 1'b0) next_state = RECEIVE;
            end
            RECEIVE: begin
                if (bit_cnt == 3'd7) next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1) next_state = FINISH;
                else next_state = IDLE; // Simple wait-for-idle or restart strategy
            end
            FINISH: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
