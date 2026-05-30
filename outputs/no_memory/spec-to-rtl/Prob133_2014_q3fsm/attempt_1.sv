module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // States
    // A: IDLE
    // B: Start sampling w (cycle 1)
    // C: Cycle 2
    // D: Cycle 3
    // E: Output decision cycle (z is valid here)
    
    typedef enum logic [2:0] {
        STATE_A = 3'd0,
        STATE_B = 3'd1,
        STATE_C = 3'd2,
        STATE_D = 3'd3,
        STATE_E = 3'd4
    } state_t;

    logic [2:0] current_state, next_state;
    logic [1:0] w_count;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_A;
            w_count <= 2'd0;
        end else begin
            current_state <= next_state;
            if (current_state == STATE_B) w_count <= (w ? 2'd1 : 2'd0);
            else if (current_state == STATE_C || current_state == STATE_D) w_count <= w_count + (w ? 1'd1 : 1'd0);
            else w_count <= 2'd0;
        end
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            STATE_A: next_state = s ? STATE_B : STATE_A;
            STATE_B: next_state = STATE_C;
            STATE_C: next_state = STATE_D;
            STATE_D: next_state = STATE_E;
            STATE_E: next_state = STATE_B;
            default: next_state = STATE_A;
        endcase
    end

    assign z = (current_state == STATE_E) && (w_count == 2'd2);

endmodule
