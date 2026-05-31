module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    logic q;
    always @(*) begin
        q = ~(a ^ b ^ c ^ d);
    end
endmodule
