module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);
    typedef enum logic [2:0] {
        STATE_A = 3'd0,
        STATE_B = 3'd1,
        STATE_C = 3'd2,
        STATE_D = 3'd3,
        STATE_E = 3'd4,
        STATE_F = 3'd5
    } state_t;

    logic [2:0] state, next_state;
    logic [1:0] x_count; // Tracks progress of x=1, 0, 1
    logic [1:0] y_timer; // Timer for y

    always_ff @(posedge clk) begin
        if (!resetn) state <= STATE_A;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: next_state = STATE_B;
            STATE_B: next_state = STATE_C;
            STATE_C: begin
                if (x_count == 2'd2 && x == 1'b1) next_state = STATE_D;
                else next_state = STATE_C;
            end
            STATE_D: begin
                if (y == 1'b1) next_state = STATE_E;
                else if (y_timer == 2'd1) next_state = STATE_F;
                else next_state = STATE_D;
            end
            STATE_E: next_state = STATE_E;
            STATE_F: next_state = STATE_F;
            default: next_state = STATE_A;
        endcase
    end

    // Sequential logic for internal counters
    always_ff @(posedge clk) begin
        if (!resetn) begin
            x_count <= 2'd0;
            y_timer <= 2'd0;
        end else begin
            case (state)
                STATE_C: begin
                    if (x_count == 2'd0 && x == 1'b1) x_count <= 2'd1;
                    else if (x_count == 2'd1 && x == 1'b0) x_count <= 2'd2;
                    else if (x_count == 2'd1 && x == 1'b1) x_count <= 2'd1;
                    else if (x_count == 2'd0 && x == 1'b0) x_count <= 2'd0;
                end
                STATE_D: begin
                    if (y == 1'b0) y_timer <= y_timer + 1'b1;
                end
            endcase
        end
    end

    assign f = (state == STATE_B);
    assign g = (state == STATE_D || state == STATE_E);

endmodule