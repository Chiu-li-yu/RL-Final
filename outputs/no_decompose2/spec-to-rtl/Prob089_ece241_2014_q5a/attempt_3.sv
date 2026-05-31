module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    logic state, next_state;

    // A serial 2's complementer is a standard FSM problem.
    // It is effectively a state machine that propagates the carry bit.
    // S0: Carry = 0
    // S1: Carry = 1
    
    // Truth Table:
    // State | x | next_state | z
    // 0     | 0 | 0          | 0
    // 0     | 1 | 1          | 1
    // 1     | 0 | 1          | 1
    // 1     | 1 | 1          | 0
    
    parameter S0 = 1'b0;
    parameter S1 = 1'b1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S0: begin
                if (x == 1'b0) begin
                    next_state = S0;
                end else begin
                    next_state = S1;
                end
            end
            S1: begin
                next_state = S1;
            end
            default: next_state = S0;
        endcase
    end
    
    assign z = (state == S0) ? x : ~x;
endmodule
