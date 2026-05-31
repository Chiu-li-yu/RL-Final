module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

    // Moore State Machine for 2's complement
    // State 0: Haven't seen a 1 yet (z = x)
    // State 1: Have seen at least one 1 (z = ~x)
    
    logic state, next_state;
    logic z_out;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            1'b0: begin
                z_out = x;
                next_state = (x == 1'b1) ? 1'b1 : 1'b0;
            end
            1'b1: begin
                z_out = ~x;
                next_state = 1'b1;
            end
            default: begin
                z_out = 1'b0;
                next_state = 1'b0;
            end
        endcase
    end

    assign z = z_out;

endmodule
