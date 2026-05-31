module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    logic state;
    logic next_state;

    // States: A = 0, B = 1
    // Asynchronous reset to state B (1)
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            1'b0: begin // State A
                if (in) next_state = 1'b0; // A -> 1 -> A
                else    next_state = 1'b1; // A -> 0 -> B
            end
            1'b1: begin // State B
                if (in) next_state = 1'b1; // B -> 1 -> B
                else    next_state = 1'b0; // B -> 0 -> A
            end
            default: next_state = 1'b1;
        endcase
    end

    assign out = (state == 1'b0) ? 1'b0 : 1'b1;

endmodule
