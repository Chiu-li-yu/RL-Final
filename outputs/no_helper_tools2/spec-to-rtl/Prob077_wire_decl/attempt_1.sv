module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    logic wire1;
    logic wire2;

    always @(*) begin
        wire1 = a & b;
        wire2 = c & d;
    end

    always @(*) begin
        // The circuit as described: two ANDs fed into an OR.
        // The output of the OR is 'out'.
        // The inverted output is 'out_n'.
    end

    assign out = wire1 | wire2;
    assign out_n = ~out;

endmodule
