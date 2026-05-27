module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);

    typedef enum logic [3:0] {
        S_IDLE,
        S_SHIFT_1,
        S_SHIFT_2,
        S_SHIFT_3,
        S_SHIFT_4,
        S_READ_DELAY_3,
        S_READ_DELAY_2,
        S_READ_DELAY_1,
        S_READ_DELAY_0,
        S_COUNTING,
        S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] shift_reg;
    logic [3:0] delay_val;
    logic [11:0] cycle_counter; // 0-999
    logic [3:0] current_delay;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_reg <= 4'b0;
            delay_val <= 4'b0;
            cycle_counter <= 12'b0;
            current_delay <= 4'b0;
        end else begin
            state <= next_state;
            
            case (state)
                S_IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                end
                S_READ_DELAY_3: delay_val[3] <= data;
                S_READ_DELAY_2: delay_val[2] <= data;
                S_READ_DELAY_1: delay_val[1] <= data;
                S_READ_DELAY_0: begin
                    delay_val[0] <= data;
                    current_delay <= delay_val; // load at end of read
                end
                S_COUNTING: begin
                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 12'b0;
                        if (current_delay > 0)
                            current_delay <= current_delay - 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end
                S_DONE: begin
                    if (ack) begin
                        state <= S_IDLE;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: if (shift_reg == 4'b1101) next_state = S_READ_DELAY_3;
            S_READ_DELAY_3: next_state = S_READ_DELAY_2;
            S_READ_DELAY_2: next_state = S_READ_DELAY_1;
            S_READ_DELAY_1: next_state = S_READ_DELAY_0;
            S_READ_DELAY_0: next_state = S_COUNTING;
            S_COUNTING: if (cycle_counter == 12'd999 && current_delay == 4'b0) next_state = S_DONE;
            S_DONE: if (ack) next_state = S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    assign counting = (state == S_COUNTING);
    assign done = (state == S_DONE);
    assign count = (state == S_COUNTING) ? current_delay : 4'b0;

endmodule
