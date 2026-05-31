module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // States: A = 0, B = 1
    logic state, next_state;

    // Output logic
    // A (0) -> out 0
    // B (1) -> out 1
    assign out = state;

    // State transition logic (Moore machine)
    // B (1) --0--> A
    // B (1) --1--> B
    // A (0) --0--> B
    // A (0) --1--> A
    always @(*) begin
        case (state)
            1'b1: begin // State B
                if (in) next_state = 1'b1;
                else    next_state = 1'b0;
            end
            1'b0: begin // State A
                if (in) next_state = 1'b0;
                else    next_state = 1'b1;
            end
            default: next_state = 1'b1;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // Reset to B
        else
            state <= next_state;
    end

endmodule
