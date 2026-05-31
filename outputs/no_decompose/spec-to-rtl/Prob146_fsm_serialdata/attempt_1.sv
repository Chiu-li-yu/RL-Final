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
            if (state == DATA) begin
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 1'b1;
            end
            
            if (next_state == IDLE) done <= 1'b0;
            if (next_state == STOP && state == DATA && bit_cnt == 3'd7) begin
                out_byte <= {in, shift_reg[7:1]}; // This logic needs to be careful
            end
            
            // Correction: update the output at the right time
            if (state == DATA && bit_cnt == 3'd7 && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= {in, shift_reg[7:1]}; 
            end else if (state == STOP) begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = (in == 1'b0) ? START : IDLE;
            START: next_state = DATA;
            DATA: next_state = (bit_cnt == 3'd7) ? STOP : DATA;
            STOP: next_state = (in == 1'b1) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

endmodule
