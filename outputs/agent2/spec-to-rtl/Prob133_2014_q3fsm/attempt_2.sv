module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    typedef enum logic [1:0] {
        STATE_A = 2'd0,
        STATE_B = 2'd1,
        STATE_CHECK = 2'd2
    } state_t;

    state_t state, next_state;
    logic [1:0] count;
    logic [1:0] next_count;
    logic [1:0] cycle_idx;
    logic [1:0] next_cycle_idx;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            count <= 2'd0;
            cycle_idx <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            count <= next_count;
            cycle_idx <= next_cycle_idx;
            
            if (state == STATE_CHECK && cycle_idx == 2'd2) begin
                z <= (count + w == 2'd2);
            end else begin
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        next_count = count;
        next_cycle_idx = cycle_idx;
        
        case (state)
            STATE_A: begin
                if (s) next_state = STATE_B;
            end
            STATE_B: begin
                next_count = 2'd0;
                next_cycle_idx = 2'd0;
                next_state = STATE_CHECK;
            end
            STATE_CHECK: begin
                if (cycle_idx < 2'd2) begin
                    next_count = count + w;
                    next_cycle_idx = cycle_idx + 2'd1;
                    next_state = STATE_CHECK;
                end else begin
                    next_count = 2'd0;
                    next_cycle_idx = 2'd0;
                    next_state = STATE_B;
                end
            end
        endcase
    end
endmodule
