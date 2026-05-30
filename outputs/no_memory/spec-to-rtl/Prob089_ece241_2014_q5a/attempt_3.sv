module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    logic state, next_state;

    // State 0: Haven't seen a '1' yet
    // State 1: Have seen a '1', invert the rest
    localparam IDLE = 1'b0;
    localparam INVERT = 1'b1;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE: next_state = (x) ? INVERT : IDLE;
            INVERT: next_state = INVERT;
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        case (state)
            IDLE: z = x; // When x is 0, z is 0; when x is 1, z is 1 (first 1 is kept)
            INVERT: z = ~x;
            default: z = 0;
        endcase
    end

endmodule