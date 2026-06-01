module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);

    // States: A, B
    // One-hot encoding: A=2'b01, B=2'b10
    logic [1:0] state;
    logic [1:0] next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = 2'b00;
        case (state)
            2'b01: begin // State A
                if (x == 1'b0) next_state = 2'b01;
                else           next_state = 2'b10;
            end
            2'b10: begin // State B
                if (x == 1'b0) next_state = 2'b10;
                else           next_state = 2'b10;
            end
            default: next_state = 2'b01;
        endcase
    end

    always_comb begin
        case (state)
            2'b01: z = (x == 1'b1);
            2'b10: z = (x == 1'b0);
            default: z = 1'b0;
        endcase
    end

endmodule
