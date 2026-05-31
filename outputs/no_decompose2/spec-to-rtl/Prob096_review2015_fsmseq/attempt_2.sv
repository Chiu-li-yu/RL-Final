module TopModule(
    input clk,
    input reset,
    input data,
    output logic start_shifting
);

    parameter IDLE = 3'd0;
    parameter S1   = 3'd1;
    parameter S11  = 3'd2;
    parameter S110 = 3'd3;
    parameter DONE = 3'd4;

    logic [2:0] current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: next_state = data ? S1 : IDLE;
            S1:   next_state = data ? S11 : IDLE;
            S11:  next_state = data ? S11 : S110;
            S110: next_state = data ? DONE : IDLE;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        start_shifting = (current_state == DONE);
    end

endmodule
