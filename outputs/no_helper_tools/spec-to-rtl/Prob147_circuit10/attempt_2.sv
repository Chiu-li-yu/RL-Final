module TopModule(
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    logic next_state;

    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        next_state = a ^ b ^ state;
        q = a ^ b ^ state;
    end

endmodule
