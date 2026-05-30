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
        // The spec mentions 'out' is driven by the OR gate
        // and 'out_n' is the inverted output.
        // It also says "the wire that feeds the NOT gate is really wire out"
        // This confirms:
        // out = (a & b) | (c & d)
        // out_n = ~out
    end

    assign out = and1_out | and2_out;
    assign out_n = ~out;

endmodule
