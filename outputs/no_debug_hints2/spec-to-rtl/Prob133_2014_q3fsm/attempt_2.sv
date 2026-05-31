module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        CHECK = 2'b10
    } state_t;

    state_t state, next_state;
    logic [1:0] cycle_cnt;
    logic [1:0] w_count;
    logic [1:0] next_cycle_cnt;
    logic [1:0] next_w_count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'b0;
            w_count <= 2'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_count <= next_w_count;
            if (state == CHECK && next_state == B) begin
                z <= (w_count == 2'd2);
            end else if (state == A) begin
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;

        case (state)
            A: begin
                if (s) begin
                    next_state = B;
                    next_cycle_cnt = 2'b0;
                    next_w_count = 2'b0;
                end
            end
            B: begin
                next_w_count = w ? (w_count + 1'b1) : w_count;
                if (cycle_cnt == 2'd2) begin
                    next_state = CHECK;
                    next_cycle_cnt = 2'b0;
                end else begin
                    next_cycle_cnt = cycle_cnt + 1'b1;
                end
            end
            CHECK: begin
                next_state = B;
                next_w_count = 2'b0;
                next_cycle_cnt = 2'b0;
            end
        endcase
    end
endmodule
