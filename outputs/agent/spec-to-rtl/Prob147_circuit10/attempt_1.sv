module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);
    logic state_reg;
    logic next_state;
    logic q_comb;

    assign state = state_reg;
    assign q = q_comb;

    // Based on the waveform analysis:
    // next_state = a ^ b ^ state
    // q = a ^ b
    always @(*) begin
        next_state = a ^ b ^ state_reg;
        q_comb = a ^ b;
    end

    always @(posedge clk) begin
        state_reg <= next_state;
    end
endmodule
