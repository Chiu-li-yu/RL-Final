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
        // out is the result of the OR gate
        // assign out = and1_out | and2_out;
        // out_n is the inverse of out
        // assign out_n = ~out;
    end

    // Direct assignments for logic gates
    assign out = and1_out | and2_out;
    assign out_n = ~out;

endmodule
