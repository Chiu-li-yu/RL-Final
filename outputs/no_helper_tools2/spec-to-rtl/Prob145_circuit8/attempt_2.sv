module TopModule (
    input clock,
    input a,
    output p,
    output q
);

    logic p_reg;
    logic q_reg;

    assign p = p_reg;
    assign q = q_reg;

    always @(*) begin
        // p depends on a and clock?
        // Let's re-analyze the waveform.
    end

endmodule