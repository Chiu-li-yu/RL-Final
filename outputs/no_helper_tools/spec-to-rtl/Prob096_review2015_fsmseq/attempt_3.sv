module TopModule (
    input clk,
    input reset,
    input data,
    output logic start_shifting
);

    logic [2:0] state, next_state;
    localparam S_IDLE = 3'd0;
    localparam S_1    = 3'd1;
    localparam S_11   = 3'd2;
    localparam S_110  = 3'd3;
    localparam S_1101 = 3'd4;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (next_state == S_1101) begin
                start_shifting <= 1'b1;
            end
        end
    end

    always_comb begin
        case (state)
            S_IDLE: next_state = data ? S_1 : S_IDLE;
            S_1:    next_state = data ? S_11 : S_IDLE;
            S_11:   next_state = data ? S_11 : S_110;
            S_110:  next_state = data ? S_1101 : S_IDLE;
            S_1101: next_state = S_1101;
            default: next_state = S_IDLE;
        endcase
    end
endmodule
