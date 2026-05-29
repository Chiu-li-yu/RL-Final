module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output logic out
);

    always @(*) begin
        out = (!b && !c) || (!a && !d) || (c && d && (a || b));
    end

endmodule
