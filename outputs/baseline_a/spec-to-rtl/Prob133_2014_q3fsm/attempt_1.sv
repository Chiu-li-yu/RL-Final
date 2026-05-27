module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    typedef enum logic [2:0] {
        STATE_A = 3'd0,
        STATE_B_0 = 3'd1,
        STATE_B_1 = 3'd2,
        STATE_B_2 = 3'd3,
        STATE_Z_HIGH = 3'd4,
        STATE_Z_LOW = 3'd5
    } state_t;

    state_t state, next_state;
    logic [1:0] count;
    logic [1:0] next_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            count <= 2'd0;
        end else begin
            state <= next_state;
            count <= next_count;
        end
    end

    always_comb begin
        next_state = state;
        next_count = count;
        z = 1'b0;

        case (state)
            STATE_A: begin
                if (s) next_state = STATE_B_0;
            end
            STATE_B_0: begin
                next_count = w ? 2'd1 : 2'd0;
                next_state = STATE_B_1;
            end
            STATE_B_1: begin
                next_count = w ? (count + 2'd1) : count;
                next_state = STATE_B_2;
            end
            STATE_B_2: begin
                next_count = w ? (count + 2'd1) : count;
                // Transitioning to result output
                if ((w ? (count + 2'd1) : count) == 2'd2) begin
                    next_state = STATE_Z_HIGH;
                end else begin
                    next_state = STATE_Z_LOW;
                end
            end
            STATE_Z_HIGH: begin
                z = 1'b1;
                next_state = STATE_B_0;
                next_count = 2'd0;
            end
            STATE_Z_LOW: begin
                z = 1'b0;
                next_state = STATE_B_0;
                next_count = 2'd0;
            end
        endcase
    end

endmodule
