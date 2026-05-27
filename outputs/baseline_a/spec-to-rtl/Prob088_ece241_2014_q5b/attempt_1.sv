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

    always_comb begin
        next_state = 2'b01;
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

    // Mealy outputs
    // A --x=0 (z=0)--> A
    // A --x=1 (z=1)--> B
    // B --x=0 (z=1)--> B
    // B --x=1 (z=0)--> B
    logic z_out;
    always_comb begin
        z_out = 1'b0;
        case (state)
            2'b01: z_out = x;
            2'b10: z_out = ~x;
            default: z_out = 1'b0;
        endcase
    end

    assign z = z_out;

endmodule
