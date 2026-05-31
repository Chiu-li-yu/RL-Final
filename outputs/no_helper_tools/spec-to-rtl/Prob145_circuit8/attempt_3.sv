module TopModule (
    input clock,
    input a,
    output p,
    output q
);

    logic state_a, state_b;

    always @(posedge clock) begin
        state_a <= a;
        state_b <= state_a;
    end

    assign p = a & clock;
    assign q = state_b;

endmodule
