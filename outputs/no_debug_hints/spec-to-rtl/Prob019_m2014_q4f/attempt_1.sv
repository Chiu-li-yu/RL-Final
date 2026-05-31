module TopModule (
    input in1,
    input in2,
    output out
);
    logic in2_inv;
    always @(*) begin
        in2_inv = ~in2;
        out = in1 & in2_inv;
    end
endmodule
