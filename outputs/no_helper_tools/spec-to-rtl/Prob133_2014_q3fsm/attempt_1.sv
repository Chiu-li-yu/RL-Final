module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    typedef enum logic [3:0] {
        A = 4'd0,
        B_0 = 4'd1, // 0 pulses, 0 cycles checked
        B_1 = 4'd2, // 1 pulse, 0 cycles checked
        B_2 = 4'd3, // 2 pulses, 0 cycles checked
        B_3 = 4'd4, // 3 pulses, 0 cycles checked
        B_4 = 4'd5, // 0 pulses, 1 cycle checked
        B_5 = 4'd6, // 1 pulse, 1 cycle checked
        B_6 = 4'd7, // 2 pulses, 1 cycle checked
        B_7 = 4'd8, // 3 pulses, 1 cycle checked
        B_8 = 4'd9, // 0 pulses, 2 cycles checked
        B_9 = 4'd10, // 1 pulse, 2 cycles checked
        B_10 = 4'd11, // 2 pulses, 2 cycles checked
        B_11 = 4'd12, // 3 pulses, 2 cycles checked
        Z_ON = 4'd13,
        Z_OFF = 4'd14
    } state_t;

    logic [3:0] state, next_state;
    logic [1:0] count_w;
    logic [1:0] cycle_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count_w <= 0;
            cycle_cnt <= 0;
        end else begin
            state <= next_state;
            if (state == A) begin
                count_w <= 0;
                cycle_cnt <= 0;
            end else if (cycle_cnt == 2) begin
                count_w <= 0;
                cycle_cnt <= 0;
            end else begin
                if (w) count_w <= count_w + 1;
                cycle_cnt <= cycle_cnt + 1;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            A: next_state = (s) ? B_0 : A;
            B_0: begin
                if (cycle_cnt == 2) next_state = (count_w + w == 2) ? Z_ON : Z_OFF;
                else next_state = B_0;
            end
            Z_ON, Z_OFF: next_state = B_0;
            default: next_state = A;
        endcase
    end

    assign z = (state == Z_ON);

endmodule
