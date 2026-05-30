module TopModule(
    input clock,
    input a,
    output p,
    output q
);
    logic q_reg;

    always @(posedge clock) begin
        q_reg <= a;
    end

    assign p = (clock & a) | (~clock & q_reg);
    assign q = q_reg;
endmodule