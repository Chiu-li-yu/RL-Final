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

    state_t state, next_state;
    logic [7:0] shift_reg;
    logic [2:0] bit_cnt;
    logic [3:0] timer; // Assuming 1 bit per clock for simplicity, 
                       // but the problem implies sampling. 
                       // Wait, does the problem imply a baud rate?
                       // "Identify start bit... wait for 8 data bits... verify stop bit"
                       // Usually this implies 1 bit per cycle. Let's assume 1 bit per cycle.

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'h00;
            done <= 1'b0;
            shift_reg <= 8'h00;
            bit_cnt <= 3'd0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
            end
            if (state == STOP && next_state == IDLE) begin
                out_byte <= shift_reg;
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA;
            DATA: next_state = (bit_cnt == 3'd7) ? STOP : DATA;
            STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            WAIT_STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) bit_cnt <= 3'd0;
        else if (state == DATA) bit_cnt <= bit_cnt + 1'b1;
        else bit_cnt <= 3'd0;
    end

endmodule