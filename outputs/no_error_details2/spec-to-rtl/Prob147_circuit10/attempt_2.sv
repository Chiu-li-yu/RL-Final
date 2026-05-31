module TopModule(
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    initial state = 0;

    always_ff @(posedge clk) begin
        state <= state ^ (a & b);
    end

    assign q = state ^ a ^ b;

endmodule