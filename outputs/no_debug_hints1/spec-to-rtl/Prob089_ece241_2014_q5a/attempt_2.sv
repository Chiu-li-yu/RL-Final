module TopModule (
    input logic clk,
    input logic areset,
    input logic x,
    output logic z
);

    logic state; // 0: S0, 1: S1
    logic next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            1'b0: next_state = (x == 1'b1) ? 1'b1 : 1'b0;
            1'b1: next_state = 1'b1;
            default: next_state = 1'b0;
        endcase
    end

    always_comb begin
        case (state)
            1'b0: z = x;
            1'b1: z = ~x;
            default: z = x;
        endcase
    end

endmodule
