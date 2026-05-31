module TopModule (
    input a,
    input b,
    input c,
    output logic out
);
    always @(*) begin
        if (a == 1'b0 && b == 1'b0 && c == 1'b0)
            out = 1'b0;
        else
            out = 1'b1;
    end
endmodule
