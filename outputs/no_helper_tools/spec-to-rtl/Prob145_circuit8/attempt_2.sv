module TopModule (
    input clock,
    input a,
    output p,
    output q
);

    logic p_int, q_int;
    logic p_d, q_d;

    assign p = p_int;
    assign q = q_int;

    always @(*) begin
        p_d = a;
        q_d = p_int;
    end

    always @(posedge clock) begin
        p_int <= p_d;
        q_int <= q_d;
    end

endmodule
