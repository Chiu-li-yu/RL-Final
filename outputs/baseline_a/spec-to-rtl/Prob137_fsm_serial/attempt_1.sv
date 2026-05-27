module TopModule (
    input clk,
    input reset,
    input in,
    output logic done
);

    typedef enum logic [3:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t state, next_state;
    logic [3:0] bit_count;
    logic [3:0] next_bit_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
        end else begin
            state <= next_state;
            bit_count <= next_bit_count;
        end
    end

    always_comb begin
        next_state = state;
        next_bit_count = bit_count;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = START;
                end
            end
            START: begin
                next_state = DATA;
                next_bit_count = 0;
            end
            DATA: begin
                if (bit_count == 4'd7) begin
                    next_state = STOP;
                end else begin
                    next_bit_count = bit_count + 1;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    done = 1'b1;
                    next_state = IDLE;
                end else begin
                    // If stop bit is not 1, wait for it
                    next_state = STOP;
                end
            end
        endcase
    end
endmodule
