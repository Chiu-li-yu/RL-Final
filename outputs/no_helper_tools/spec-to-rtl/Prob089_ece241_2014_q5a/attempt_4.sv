module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

    // The serial 2's complementer:
    // The bits arrive LSB first.
    // 2's complement = bitwise NOT + 1.
    // This is equivalent to: Keep all bits up to and including the first '1',
    // then invert all subsequent bits.
    
    // Mealy implementation:
    // State: 0 (not yet seen 1), 1 (seen a 1)
    
    logic state, next_state;
    logic out;
    
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end
    
    always @(*) begin
        if (state == 1'b0) begin
            out = x;
            next_state = (x == 1'b1) ? 1'b1 : 1'b0;
        end else begin
            out = ~x;
            next_state = 1'b1;
        end
    end
    
    assign z = out;

endmodule
