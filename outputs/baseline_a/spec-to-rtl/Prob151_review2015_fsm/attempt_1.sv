module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    input logic done_counting,
    input logic ack,
    output logic shift_ena,
    output logic counting,
    output logic done
);

    typedef enum logic [3:0] {
        IDLE,
        S1,
        S11,
        S110,
        SHIFT,
        COUNT,
        WAIT_ACK
    } state_t;

    state_t state, next_state;
    logic [2:0] shift_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                if (shift_count < 3'd3)
                    shift_count <= shift_count + 1'b1;
                else
                    shift_count <= 3'd0;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    always_comb begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (data) next_state = S1;
            end
            S1: begin
                if (data) next_state = S11;
                else next_state = IDLE;
            end
            S11: begin
                if (!data) next_state = S110;
                else next_state = S11;
            end
            S110: begin
                if (data) next_state = SHIFT;
                else next_state = IDLE;
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3) begin
                    next_state = COUNT;
                end
            end
            COUNT: begin
                counting = 1'b1;
                if (done_counting) next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                done = 1'b1;
                if (ack) next_state = IDLE;
            end
        endcase
    end
endmodule
