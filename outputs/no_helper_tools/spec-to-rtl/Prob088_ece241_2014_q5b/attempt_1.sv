module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot encoding: State A = 2'b01, State B = 2'b10
    logic [1:0] state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = 2'b01;
        case (state)
            2'b01: begin // State A
                if (x) next_state = 2'b10;
                else   next_state = 2'b01;
            end
            2'b10: begin // State B
                next_state = 2'b10;
            end
            default: next_state = 2'b01;
        endcase
    end

    // Mealy output: z depends on state and input
    assign z = (state == 2'b01 && x == 1'b1) || (state == 2'b10 && x == 1'b0);

endmodule
