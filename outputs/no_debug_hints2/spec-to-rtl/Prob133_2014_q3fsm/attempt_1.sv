module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    typedef enum logic [2:0] {
        STATE_A = 3'b000,
        STATE_B_0 = 3'b001,
        STATE_B_1 = 3'b010,
        STATE_B_2 = 3'b011,
        STATE_CHECK = 3'b100
    } state_t;

    state_t current_state, next_state;
    logic [1:0] w_count;
    logic [1:0] w_count_next;
    logic z_next;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_A;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            w_count <= w_count_next;
            z <= z_next;
        end
    end

    always @(*) begin
        next_state = current_state;
        w_count_next = w_count;
        z_next = 1'b0;

        case (current_state)
            STATE_A: begin
                if (s) next_state = STATE_B_0;
            end
            STATE_B_0: begin
                w_count_next = w ? 2'b01 : 2'b00;
                next_state = STATE_B_1;
            end
            STATE_B_1: begin
                w_count_next = w ? (w_count + 1'b1) : w_count;
                next_state = STATE_B_2;
            end
            STATE_B_2: begin
                w_count_next = w ? (w_count + 1'b1) : w_count;
                next_state = STATE_CHECK;
            end
            STATE_CHECK: begin
                z_next = (w_count == 2'd2);
                w_count_next = 2'b00;
                next_state = STATE_B_0;
            end
            default: next_state = STATE_A;
        endcase
    end
endmodule
