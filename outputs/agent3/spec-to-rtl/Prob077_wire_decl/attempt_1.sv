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
        // out is driven by OR of wire1 and wire2
        // per requirements: out feeds the NOT gate for out_n
        // so out can be used as the source for out_n
    end

    assign out = wire1 | wire2;
    assign out_n = ~out;

endmodule