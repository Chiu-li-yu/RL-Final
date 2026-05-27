module TopModule (
    input clk,
    input reset,
    output logic shift_ena
);
    // State definition
    typedef enum logic [2:0] {
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        DONE = 3'd4
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = DONE;
            DONE: next_state = DONE;
            default: next_state = S0;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        if (current_state == S0 || current_state == S1 || current_state == S2 || current_state == S3) begin
            shift_ena = 1'b1;
        end else begin
            shift_ena = 1'b0;
        end
    end

endmodule
