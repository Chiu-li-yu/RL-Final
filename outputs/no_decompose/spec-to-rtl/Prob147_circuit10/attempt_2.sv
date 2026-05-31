module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    logic state_reg;
    assign state = state_reg;
    assign q = state_reg ^ a ^ b;

    always @(posedge clk) begin
        state_reg <= a ^ b;
    end

endmodule
