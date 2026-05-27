module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot encoding
    // State A: 2'b01
    // State B: 2'b10
    logic [1:0] state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = 2'b00;
        case (state)
            2'b01: begin // A
                if (x == 1'b0) next_state = 2'b01;
                else           next_state = 2'b10;
            end
            2'b10: begin // B
                next_state = 2'b10;
            end
            default: next_state = 2'b01;
        endcase
    end

    always @(*) begin
        case (state)
            2'b01: z = (x == 1'b1);
            2'b10: z = (x == 1'b0);
            default: z = 1'b0;
        endcase
    end

endmodule
