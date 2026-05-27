module TopModule (
    input a,
    input b,
    input c,
    input d,
    output logic out,
    output logic out_n
);

    logic and1_out;
    logic and2_out;

    always @(*) begin
        and1_out = a & b;
        and2_out = c & d;
    end

    always @(*) begin
        out = and1_out | and2_out;
        out_n = ~out;
    end

endmodule
