module TopModule (
    input logic clk,
    input logic areset,
    input logic x,
    output logic z
);

    // One-hot encoding: A=2'b01, B=2'b10
    logic [1:0] state, next_state;

    localparam A = 2'b01;
    localparam B = 2'b10;

    // State register
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (state)
            A: begin
                if (x == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            B: begin
                next_state = B;
            end
            default: next_state = A;
        endcase
    end

    // Output logic (Mealy: z depends on state and x)
    always_comb begin
        case (state)
            A: begin
                if (x == 1'b0)
                    z = 1'b0;
                else
                    z = 1'b1;
            end
            B: begin
                if (x == 1'b0)
                    z = 1'b1;
                else
                    z = 1'b0;
            end
            default: z = 1'b0;
        endcase
    end

endmodule
