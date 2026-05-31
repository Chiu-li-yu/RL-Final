module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    logic q_int;

    always @(*) begin
        q_int = ~(a ^ b ^ c ^ d);
    end

    assign q = q_int;

endmodule