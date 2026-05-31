module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);
    // The problem: z needs to be 1 in the *following* cycle after 3 checks of w.
    // So if cycle 1, 2, 3 check w, then in cycle 4 we evaluate z.

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        C0 = 2'd1,
        C1 = 2'd2,
        C2 = 2'd3
    } state_t;

    state_t state, next_state;
    logic [1:0] cnt;
    logic [1:0] next_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            cnt <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            
            // Output logic: check count at the end of C2
            if (state == C2) begin
                z <= ((cnt + w) == 2'd2);
            end else begin
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        case (state)
            IDLE: if (s) next_state = C0;
            C0: begin
                next_cnt = w ? 2'd1 : 2'd0;
                next_state = C1;
            end
            C1: begin
                next_cnt = cnt + (w ? 2'd1 : 2'd0);
                next_state = C2;
            end
            C2: begin
                next_state = C0;
                next_cnt = 2'd0;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
