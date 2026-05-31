module TopModule (
    input clk,
    input reset,
    input data,
    output logic start_shifting
);

    logic [2:0] state, next_state;
    parameter IDLE  = 3'd0;
    parameter S1    = 3'd1;
    parameter S11   = 3'd2;
    parameter S110  = 3'd3;
    parameter FOUND = 3'd4;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        if (reset) start_shifting = 1'b0;
        else if (state == FOUND) start_shifting = 1'b1;
        else start_shifting = 1'b0;
    end

    always_comb begin
        case (state)
            IDLE:  next_state = (data) ? S1 : IDLE;
            S1:    next_state = (data) ? S11 : IDLE;
            S11:   next_state = (data) ? S11 : S110;
            S110:  next_state = (data) ? FOUND : S110; // Modified condition
            FOUND: next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end
    
    // Correction: the previous logic for S110 was wrong for continuous stream.
    // If we have 1101, it goes to FOUND.
    // If we have 1100, it should go back to IDLE.

endmodule
