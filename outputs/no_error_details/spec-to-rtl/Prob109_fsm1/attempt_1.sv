module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    logic state; // B=1, A=0
    logic next_state;

    // State B is 1, State A is 0
    // Reset to B
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            1'b1: // State B
                if (in) next_state = 1'b1;
                else    next_state = 1'b0;
            1'b0: // State A
                if (in) next_state = 1'b0;
                else    next_state = 1'b1;
            default: next_state = 1'b1;
        endcase
    end

    assign out = state;

endmodule