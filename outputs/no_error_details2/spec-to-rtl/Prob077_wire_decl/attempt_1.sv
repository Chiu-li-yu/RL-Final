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
        // The spec says "The second layer there is an OR gate to OR the two AND outputs, connected the output 'out'."
        // So out = and1_out | and2_out
        // And "Additionally, there is an inverted output 'out_n'"
    end

    assign out = and1_out | and2_out;
    assign out_n = ~out;

endmodule
