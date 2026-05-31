module TopModule(
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    always_ff @(posedge clk) begin
        state <= state ^ (a & b);
    end

    always @(*) begin
        q = state ^ a ^ b;
    end

endmodule