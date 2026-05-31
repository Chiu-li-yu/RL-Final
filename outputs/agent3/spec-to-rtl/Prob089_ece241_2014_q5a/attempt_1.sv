module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    // Moore FSM for serial 2's complementer
    // State 0: Haven't seen a '1' yet
    // State 1: Have seen a '1' already
    logic state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            1'b0: begin
                if (x == 1'b1) next_state = 1'b1;
                else next_state = 1'b0;
            end
            1'b1: begin
                next_state = 1'b1;
            end
        endcase
    end

    always @(*) begin
        case (state)
            1'b0: z = x; // When no 1 has been seen, z = x
            1'b1: z = ~x; // When a 1 has been seen, invert x
        endcase
    end
endmodule
