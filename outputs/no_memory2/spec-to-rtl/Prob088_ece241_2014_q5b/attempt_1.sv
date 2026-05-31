module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    logic [1:0] state, next_state;
    
    // One-hot encoding
    localparam A = 2'b01;
    localparam B = 2'b10;

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (x) next_state = B;
                else   next_state = A;
            end
            B: begin
                next_state = B;
            end
            default: next_state = A;
        endcase
    end

    // Output logic (Mealy: output depends on state and input)
    always @(*) begin
        case (state)
            A: begin
                if (x) z = 1'b1;
                else   z = 1'b0;
            end
            B: begin
                if (x) z = 1'b0;
                else   z = 1'b1;
            end
            default: z = 1'b0;
        endcase
    end

endmodule
