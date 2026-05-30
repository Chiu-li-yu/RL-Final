module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    // State definition
    localparam IDLE = 1'b0;
    localparam INVERT = 1'b1;

    logic state, next_state;
    logic z_out;

    // Sequential logic for state register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (x)
                    next_state = INVERT;
                else
                    next_state = IDLE;
            end
            INVERT: begin
                next_state = INVERT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore machine)
    // IDLE: output 0
    // INVERT: output ~x
    always @(*) begin
        if (state == IDLE)
            z_out = (x == 1'b1) ? 1'b1 : 1'b0; // Correct output for LSB
        else
            z_out = ~x;
    end

    assign z = z_out;

endmodule
