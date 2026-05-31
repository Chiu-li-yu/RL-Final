module TopModule(
    input clk,
    input reset,
    input data,
    output logic start_shifting
);

    localparam S_IDLE = 3'd0;
    localparam S_1    = 3'd1;
    localparam S_11   = 3'd2;
    localparam S_110  = 3'd3;
    localparam S_DONE = 3'd4;

    logic [2:0] state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: next_state = data ? S_1 : S_IDLE;
            S_1:    next_state = data ? S_11 : S_IDLE;
            S_11:   next_state = data ? S_11 : S_110;
            S_110:  next_state = data ? S_DONE : S_IDLE;
            S_DONE: next_state = S_DONE;
            default: next_state = S_IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            start_shifting <= 1'b0;
        end else if (state == S_DONE || (state == S_110 && data == 1'b1)) begin
            start_shifting <= 1'b1;
        end
    end

endmodule
