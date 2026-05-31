module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic q
);
    always @(*) begin
        q = c | b;
    end
endmodule
