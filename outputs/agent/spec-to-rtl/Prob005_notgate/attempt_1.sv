module TopModule (
    input in,
    output logic out
);

    always @(*) begin
        out = ~in;
    end

endmodule
