module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    logic state_ff;
    logic next_state;
    logic q_comb;

    assign state = state_ff;
    assign q = q_comb;

    always @(posedge clk) begin
        state_ff <= next_state;
    end

    always @(*) begin
        next_state = a ^ b ^ state_ff;
        q_comb = a ^ b;
    end

endmodule
