module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);
    logic state_ff;

    // q = a ^ b ^ state
    assign q = a ^ b ^ state_ff;

    // next_state = (a & b) | (state & (a ^ b))
    logic next_state;
    always @(*) begin
        next_state = (a & b) | (state_ff & (a ^ b));
    end

    always_ff @(posedge clk) begin
        state_ff <= next_state;
    end

    assign state = state_ff;

endmodule