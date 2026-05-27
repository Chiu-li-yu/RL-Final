module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    logic and1_out;
    logic and2_out;
    logic or_out;

    always @(*) begin
        and1_out = a & b;
        and2_out = c & d;
        or_out = and1_out | and2_out;
    end

    assign out = or_out;
    assign out_n = ~or_out;

endmodule
