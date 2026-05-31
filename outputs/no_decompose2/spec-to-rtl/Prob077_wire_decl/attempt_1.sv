module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
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
        // out is the output of the OR gate
        // out_n is the inverted output
    end

    assign out = (and1_out | and2_out);
    assign out_n = ~out;

endmodule
