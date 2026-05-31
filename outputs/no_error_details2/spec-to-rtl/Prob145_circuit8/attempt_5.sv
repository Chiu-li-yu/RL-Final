module TopModule(
    input clock,
    input a,
    output p,
    output q
);
    logic p_l, q_l;

    always_latch begin
        if (clock) begin
            p_l = a;
        end
    end

    always_ff @(posedge clock) begin
        q_l <= p_l;
    end

    assign p = p_l;
    assign q = q_l;
endmodule
