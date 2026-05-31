module TopModule (
    input  a,
    input  b,
    output logic q
);
    always @(*) begin
        q = a & b;
    end
endmodule
