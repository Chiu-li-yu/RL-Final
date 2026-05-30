module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    // Moore FSM: 0 = No carry (first 1 encountered), 1 = Carry (after first 1)
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
                if (x == 1'b1)
                    next_state = 1'b1;
                else
                    next_state = 1'b0;
            end
            1'b1: begin
                z = ~x;
                next_state = 1'b1;
            end
            default: begin
                z = 1'b0;
                next_state = 1'b0;
            end
        endcase
    end
endmodule
