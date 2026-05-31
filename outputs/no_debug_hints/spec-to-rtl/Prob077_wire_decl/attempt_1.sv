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

    always @(*) begin
        and1_out = a & b;
        and2_out = c & d;
    end

    always @(*) begin
        // The spec says "the wire that feeds the NOT gate is really wire out"
        // So we can assign out first, then assign out_n
        // However, standard Verilog/Logic would just be:
    end

    assign out = and1_out | and2_out;
    assign out_n = ~out;

endmodule
