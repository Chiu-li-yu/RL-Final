module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out,
    output logic out_n
);

    logic w1;
    logic w2;

    always @(*) begin
        w1 = a & b;
        w2 = c & d;
        out = w1 | w2;
        out_n = ~out;
    end

endmodule
