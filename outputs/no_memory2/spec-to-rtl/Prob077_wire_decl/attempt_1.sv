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
        // The spec says out is the OR of the two AND gates
        // and out_n is the inverted out.
    end

    assign out = and1_out | and2_out;
    assign out_n = ~out;

endmodule
