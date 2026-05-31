module TopModule (
    input d,
    input ena,
    output q
);

    logic q_reg;

    assign q = q_reg;

    always @(*) begin
        if (ena) begin
            q_reg = d;
        end
    end

endmodule