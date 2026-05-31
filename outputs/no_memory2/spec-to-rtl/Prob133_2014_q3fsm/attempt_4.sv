module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    typedef enum logic {
        STATE_A = 1'b0,
        STATE_B = 1'b1
    } state_t;

    logic state, next_state;
    logic [1:0] count;          // 追蹤觀察了幾個 cycle (0, 1, 2)
    logic [1:0] w_ones;         // 統計 w=1 的次數
    logic next_z;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            count <= 2'b0;
            w_ones <= 2'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            if (state == STATE_B) begin
                if (count == 2'd2) begin
                    count <= 2'd0;
                    w_ones <= 2'd0;
                    z <= next_z;
                end else begin
                    count <= count + 1'b1;
                    if (w) w_ones <= w_ones + 1'b1;
                    z <= 1'b0;
                end
            end else begin
                count <= 2'd0;
                w_ones <= 2'd0;
                z <= 1'b0;
            end
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            STATE_A: if (s) next_state = STATE_B;
            STATE_B: next_state = STATE_B;
        endcase

        next_z = (w_ones + (w ? 1'b1 : 1'b0) == 2'd2);
    end

endmodule
