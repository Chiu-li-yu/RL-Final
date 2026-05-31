module TopModule (
    input logic clk,
    input logic areset,
    input logic x,
    output logic z
);

    // Moore machine for 2's complement
    // State 0: no 1s seen yet
    // State 1: at least one 1 seen
    logic state;
    logic next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    always_comb begin
        if (state == 1'b0)
            next_state = (x == 1'b1) ? 1'b1 : 1'b0;
        else
            next_state = 1'b1;
    end

    // Moore output:
    // When state 0: output z = x (if x is 0, output 0; if x is 1, output 1)
    // When state 1: output z = !x (flip all bits after first 1)
    always_comb begin
        if (state == 1'b0)
            z = x;
        else
            z = ~x;
    end

endmodule
