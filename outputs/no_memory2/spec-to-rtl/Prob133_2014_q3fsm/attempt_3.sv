module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    typedef enum logic [2:0] {
        STATE_A = 3'd0,
        STATE_B = 3'd1,
        STATE_C = 3'd2,
        STATE_D = 3'd3,
        STATE_E = 3'd4
    } state_t;

    state_t current_state, next_state;
    logic [1:0] count;
    logic z_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_A;
            count <= 2'b00;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            if (current_state == STATE_A) begin
                count <= 2'b00;
                z <= 1'b0;
            end else if (current_state == STATE_E) begin
                count <= 2'b00;
                z <= z_reg;
            end else begin
                if (w) count <= count + 1'b1;
            end
        end
    end

    always @(*) begin
        next_state = current_state;
        z_reg = 1'b0;
        case (current_state)
            STATE_A: next_state = (s) ? STATE_B : STATE_A;
            STATE_B: next_state = STATE_C;
            STATE_C: next_state = STATE_D;
            STATE_D: begin
                next_state = STATE_E;
                z_reg = (count + w == 2'd2);
            end
            STATE_E: next_state = STATE_B;
            default: next_state = STATE_A;
        endcase
    end

endmodule
