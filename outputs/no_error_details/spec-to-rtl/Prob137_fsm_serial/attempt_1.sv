module TopModule (
    input clk,
    input reset,
    input in,
    output logic done
);

    typedef enum logic [2:0] {
        IDLE  = 3'd0,
        START = 3'd1,
        DATA  = 3'd2,
        STOP  = 3'd3,
        WAIT  = 3'd4
    } state_t;

    state_t state, next_state;
    logic [3:0] bit_count;
    logic [7:0] shift_reg;
    logic done_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            if (state == START) begin
                bit_count <= 0;
            end else if (state == DATA) begin
                bit_count <= bit_count + 1;
                shift_reg <= {in, shift_reg[7:1]};
            end
            
            if (state == STOP && in == 1'b1 && next_state == IDLE)
                done_reg <= 1'b1;
            else
                done_reg <= 0;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE:  if (in == 1'b0) next_state = START;
            START: next_state = DATA;
            DATA:  if (bit_count == 4'd7) next_state = STOP;
            STOP:  if (in == 1'b1) next_state = IDLE; else next_state = WAIT;
            WAIT:  if (in == 1'b1) next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule