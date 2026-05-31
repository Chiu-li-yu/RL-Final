module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);
    logic next_state;
    logic state_reg;

    assign state = state_reg;
    assign q = state_reg ^ a ^ b;

    always_ff @(posedge clk) begin
        state_reg <= next_state;
    end

    always_comb begin
        next_state = state_reg ^ a ^ b;
    end
endmodule
