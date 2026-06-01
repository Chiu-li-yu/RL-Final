module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Mealy machine might be simpler for 2's complement
    // Input is LSB first.
    // 0 -> 0, 1 -> 1 (until first 1)
    // After first 1, 0 -> 1, 1 -> 0
    
    logic state; // 0 = before first 1, 1 = after first 1

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else if (state == 1'b0 && x == 1'b1)
            state <= 1'b1;
        else
            state <= state;
    end

    // Moore machine output: 
    // State 0: output = x
    // State 1: output = !x
    assign z = (state == 1'b0) ? x : ~x;

endmodule
