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

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
        end else begin
            state <= next_state;
            if (state == START)
                bit_count <= 4'd0;
            else if (state == DATA)
                bit_count <= bit_count + 1'b1;
        end
    end

    always_comb begin
        next_state = state;
        done = 1'b0;
        case (state)
            IDLE:  if (in == 1'b0) next_state = START;
            START: next_state = DATA;
            DATA:  if (bit_count == 4'd7) next_state = STOP;
            STOP:  begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                    done = 1'b1;
                end else begin
                    next_state = WAIT;
                end
            end
            WAIT:  if (in == 1'b1) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
endmodule