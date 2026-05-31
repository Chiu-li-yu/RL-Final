module TopModule (
    input clock,
    input a,
    output p,
    output q
);
    logic q_reg;

    always @(posedge clock or negedge clock) begin
        if (~clock) begin
            q_reg <= a;
        end
    end

    assign p = a | q_reg;
    assign q = q_reg;

endmodule
