module TopModule (
    input a,
    input b,
    output logic out
);

    always @(*) begin
        out = ~(a | b);
    end

endmodule
