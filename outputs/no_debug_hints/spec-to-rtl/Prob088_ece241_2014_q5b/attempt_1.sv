module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    // State definitions (One-hot encoding)
    // A: 2'b01
    // B: 2'b10
    logic [1:0] state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = 2'b01;
        case (state)
            2'b01: begin // State A
                if (x == 1'b0) next_state = 2'b01;
                else           next_state = 2'b10;
            end
            2'b10: begin // State B
                next_state = 2'b10;
            end
            default: next_state = 2'b01;
        endcase
    end

    // Mealy output logic (z)
    always @(*) begin
        case (state)
            2'b01: z = (x == 1'b1) ? 1'b1 : 1'b0; // A--x=1-->B(z=1)
            2'b10: z = (x == 1'b0) ? 1'b1 : 1'b0; // B--x=0-->B(z=1), B--x=1-->B(z=0)
            default: z = 1'b0;
        endcase
    end
endmodule
