module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic [3:0] count,
    output logic counting,
    output logic done,
    input logic ack
);

    typedef enum logic [3:0] {
        S_IDLE,
        S_PAT_1,
        S_PAT_11,
        S_PAT_110,
        S_READ_DELAY,
        S_COUNTING,
        S_DONE
    } state_t;

    state_t state, next_state;
    logic [3:0] delay_reg;
    logic [2:0] shift_count;
    logic [13:0] cycle_counter; // (15+1)*1000 = 16000 < 2^14
    logic [3:0] current_delay;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            delay_reg <= 4'b0;
            shift_count <= 3'b0;
            cycle_counter <= 14'b0;
            current_delay <= 4'b0;
        end else begin
            state <= next_state;

            if (state == S_READ_DELAY) begin
                if (shift_count < 3'd4) begin
                    delay_reg <= {delay_reg[2:0], data};
                    shift_count <= shift_count + 1'b1;
                end
            end else if (state == S_IDLE) begin
                shift_count <= 3'b0;
            end

            if (state == S_READ_DELAY && shift_count == 3'd3) begin
                current_delay <= {delay_reg[2:0], data};
                cycle_counter <= 14'd999;
            end else if (state == S_COUNTING) begin
                if (cycle_counter == 14'd0) begin
                    if (current_delay > 4'd0) begin
                        current_delay <= current_delay - 1'b1;
                        cycle_counter <= 14'd999;
                    end else begin
                        cycle_counter <= 14'd0;
                    end
                end else begin
                    cycle_counter <= cycle_counter - 1'b1;
                end
            end
        end
    end

    always_at(*) begin
        next_state = state;
        case (state)
            S_IDLE: begin
                if (data) next_state = S_PAT_1;
            end
            S_PAT_1: begin
                if (data) next_state = S_PAT_11;
                else next_state = S_IDLE;
            end
            S_PAT_11: begin
                if (!data) next_state = S_PAT_110;
                else next_state = S_PAT_11;
            end
            S_PAT_110: begin
                if (data) next_state = S_READ_DELAY;
                else next_state = S_IDLE;
            end
            S_READ_DELAY: begin
                if (shift_count == 3'd3) next_state = S_COUNTING;
            end
            S_COUNTING: begin
                if (current_delay == 4'd0 && cycle_counter == 14'd0) next_state = S_DONE;
            end
            S_DONE: begin
                if (ack) next_state = S_IDLE;
            end
        endcase
    end

    assign counting = (state == S_COUNTING);
    assign done = (state == S_DONE);
    assign count = (state == S_COUNTING) ? current_delay : 4'b0;

endmodule
