module TopModule (
    input clk,
    input reset,
    input data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input ack
);
    typedef enum logic [2:0] {
        S_IDLE, S_S1, S_S11, S_S110, S_LOAD, S_COUNT, S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] delay;
    logic [3:0] bit_counter;
    logic [15:0] cycle_counter; // For counting up to 6000

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            delay <= 0;
            bit_counter <= 0;
            cycle_counter <= 0;
            count <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            state <= next_state;

            case (state)
                S_IDLE: begin
                    counting <= 0;
                    done <= 0;
                end
                S_LOAD: begin
                    if (bit_counter < 3) begin
                        delay <= {delay[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end else begin
                        delay <= {delay[2:0], data};
                        bit_counter <= 0;
                        count <= {delay[2:0], data};
                    end
                end
                S_COUNT: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (count > 0) count <= count - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    counting <= 1;
                end
                S_DONE: begin
                    counting <= 0;
                    done <= 1;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: if (data) next_state = S_S1;
            S_S1:   next_state = data ? S_S11 : S_IDLE;
            S_S11:  next_state = data ? S_S11 : S_S110;
            S_S110: next_state = data ? S_LOAD : S_IDLE;
            S_LOAD: if (bit_counter == 3) next_state = S_COUNT;
            S_COUNT: if (count == 0 && cycle_counter == 999) next_state = S_DONE;
            S_DONE: if (ack) next_state = S_IDLE;
        endcase
    end
endmodule
