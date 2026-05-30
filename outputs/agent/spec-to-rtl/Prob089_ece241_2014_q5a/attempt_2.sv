module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    // Moore FSM for 2's complement:
    // State 0: Haven't seen a '1' yet. Output is input (x).
    // State 1: Have seen a '1'. Output is inverted input (~x).

    logic state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            1'b0: begin
                z = x;
                next_state = (x == 1'b1) ? 1'b1 : 1'b0;
            end
            1'b1: begin
                z = ~x;
                next_state = 1'b1;
            end
            default: begin
                z = x;
                next_state = 1'b0;
            end
        endcase
    end
endmodule
