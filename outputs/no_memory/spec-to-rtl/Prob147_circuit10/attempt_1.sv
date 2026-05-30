module TopModule(
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    always @(posedge clk) begin
        state <= a ^ b;
    end

    always @(*) begin
        q = a ^ b ^ state;
    end

endmodule