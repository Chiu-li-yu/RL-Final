module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    logic and1;
    logic and2;

    always @(*) begin
        and1 = a & b;
        and2 = c & d;
    end

    always @(*) begin
        // The output 'out' is the result of the OR gate
        // The problem specifies the OR gate is the second layer.
        // We can assign out here.
    end

    assign out = and1 | and2;
    assign out_n = ~out;

endmodule
