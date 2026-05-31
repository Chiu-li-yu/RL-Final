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

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'd0;
            bit_cnt <= 3'd0;
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            state <= next_state;
            if (state == DATA) begin
                shift_reg[bit_cnt] <= in;
                bit_cnt <= bit_cnt + 3'd1;
            end else begin
                bit_cnt <= 3'd0;
            end
            
            if (next_state == IDLE && state == STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE:  if (in == 1'b0) next_state = DATA; // Start bit detected
            DATA:  if (bit_cnt == 3'd7) next_state = STOP;
            STOP:  if (in == 1'b1) next_state = IDLE;
                   else next_state = STOP; // Wait for stop bit
            default: next_state = IDLE;
        endcase
    end

endmodule