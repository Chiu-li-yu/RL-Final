module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output logic z
);

    // States
    localparam S_A  = 2'd0;
    localparam S_B  = 2'd1;
    localparam S_C  = 2'd2; // Checking w

    logic [1:0] state, next_state;
    logic [1:0] count;
    logic [1:0] cycle_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_A;
            z <= 1'b0;
            count <= 2'd0;
            cycle_cnt <= 2'd0;
        end else begin
            state <= next_state;

            if (state == S_A) begin
                z <= 1'b0;
            end else if (state == S_B) begin
                count <= (w ? 2'd1 : 2'd0);
                cycle_cnt <= 2'd1;
                z <= 1'b0;
            end else if (state == S_C) begin
                if (cycle_cnt < 2'd3) begin
                    count <= count + (w ? 1'b1 : 1'b0);
                    cycle_cnt <= cycle_cnt + 2'd1;
                end
                
                if (cycle_cnt == 2'd2) begin
                    z <= ((count + (w ? 1'b1 : 1'b0)) == 2'd2);
                end else begin
                    z <= 1'b0;
                end
            end
        end
    end

    always @(*) begin
        case (state)
            S_A: next_state = s ? S_B : S_A;
            S_B: next_state = S_C;
            S_C: next_state = (cycle_cnt == 2'd2) ? S_B : S_C;
            default: next_state = S_A;
        endcase
    end

endmodule
