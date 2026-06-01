module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    typedef enum logic [3:0] {
        STATE_A = 4'd0,
        STATE_B_0 = 4'd1,
        STATE_B_1 = 4'd2,
        STATE_B_2 = 4'd3,
        STATE_CHECK = 4'd4
    } state_t;

    logic [3:0] state, next_state;
    logic [1:0] count_w;
    logic [1:0] count_clk;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            count_w <= 2'b0;
            count_clk <= 2'b0;
        end else begin
            state <= next_state;
            if (state == STATE_A) begin
                count_w <= 2'b0;
                count_clk <= 2'b0;
            end else if (state == STATE_CHECK) begin
                count_w <= 2'b0;
                count_clk <= 2'b0;
            end else begin
                count_w <= count_w + w;
                count_clk <= count_clk + 1'b1;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: next_state = s ? STATE_B_0 : STATE_A;
            STATE_B_0: next_state = STATE_B_1;
            STATE_B_1: next_state = STATE_B_2;
            STATE_B_2: next_state = STATE_CHECK;
            STATE_CHECK: next_state = STATE_B_0;
            default: next_state = STATE_A;
        endcase
    end

    always @(*) begin
        if (state == STATE_CHECK && count_w == 2'd2)
            z = 1'b1;
        else
            z = 1'b0;
    end

endmodule
