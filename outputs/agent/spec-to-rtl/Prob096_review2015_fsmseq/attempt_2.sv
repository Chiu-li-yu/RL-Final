module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic start_shifting
);

    localparam IDLE  = 3'd0;
    localparam S1    = 3'd1;
    localparam S11   = 3'd2;
    localparam S110  = 3'd3;
    localparam FOUND = 3'd4;

    logic [2:0] current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE:  next_state = data ? S1 : IDLE;
            S1:    next_state = data ? S11 : IDLE;
            S11:   next_state = data ? S11 : S110;
            S110:  next_state = data ? FOUND : IDLE;
            FOUND: next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            start_shifting <= 1'b0;
        end else if (current_state == FOUND || next_state == FOUND) begin
            start_shifting <= 1'b1;
        end
    end

endmodule
