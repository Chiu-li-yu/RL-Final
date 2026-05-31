module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    logic state; // 0: S0, 1: S1

    // Sequential logic for state transition
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            case (state)
                1'b0: state <= (x) ? 1'b1 : 1'b0;
                1'b1: state <= 1'b1;
            endcase
    end

    // Combinational logic for output
    always @(*) begin
        case (state)
            1'b0: z = x;
            1'b1: z = ~x;
            default: z = 1'b0;
        endcase
    end
endmodule
