module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out
);

    always @(*) begin
        out = b ^ d;
    end

endmodule
