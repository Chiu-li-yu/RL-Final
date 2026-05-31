module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    localparam S_A = 2'd0;
    localparam S_B = 2'd1;

    logic [1:0] state, next_state;
    logic [1:0] w_count;
    logic [1:0] cycle_cnt;
    logic next_z;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_A;
            w_count <= 0;
            cycle_cnt <= 0;
            z <= 0;
        end else begin
            state <= next_state;
            if (state == S_A) begin
                w_count <= 0;
                cycle_cnt <= 0;
                z <= 0;
            end else begin
                cycle_cnt <= cycle_cnt + 1;
                if (w) w_count <= w_count + 1;
                
                if (cycle_cnt == 2) begin
                    z <= (w_count + w == 2);
                    cycle_cnt <= 0;
                    w_count <= 0;
                end else begin
                    z <= 0;
                end
            end
        end
    end

    always @(*) begin
        case (state)
            S_A: next_state = (s) ? S_B : S_A;
            S_B: next_state = S_B;
            default: next_state = S_A;
        endcase
    end
endmodule
