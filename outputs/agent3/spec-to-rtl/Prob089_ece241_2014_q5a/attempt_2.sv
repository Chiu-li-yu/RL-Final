module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    // Serial 2's complementer (Moore FSM)
    // The logic is:
    // Bits up to and including the first '1' remain unchanged.
    // Bits after the first '1' are inverted.
    
    // State 0: Haven't encountered the first '1'
    // State 1: Already encountered the first '1'
    
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
            1'b0: next_state = (x == 1'b1) ? 1'b1 : 1'b0;
            1'b1: next_state = 1'b1;
            default: next_state = 1'b0;
        endcase
    end

    // Moore output: depends only on current state
    // If state 0: x=0, z=0; x=1, z=1
    // If state 1: x=0, z=1; x=1, z=0
    always @(*) begin
        case (state)
            1'b0: z = x;
            1'b1: z = ~x;
            default: z = 1'b0;
        endcase
    end
endmodule
