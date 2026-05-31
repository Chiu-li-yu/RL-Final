module TopModule (
    input logic clk,
    input logic reset,
    input logic data,
    output logic start_shifting
);

    logic [2:0] current_state, next_state;

    parameter IDLE  = 3'b000;
    parameter S1    = 3'b001;
    parameter S11   = 3'b010;
    parameter S110  = 3'b011;
    parameter FOUND = 3'b100;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            IDLE:  next_state = data ? S1    : IDLE;
            S1:    next_state = data ? S11   : IDLE;
            S11:   next_state = data ? S11   : S110;
            S110:  next_state = data ? FOUND : IDLE;
            FOUND: next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

    assign start_shifting = (current_state == FOUND);

endmodule