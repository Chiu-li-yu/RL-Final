module TopModule (
    input  a,
    input  b,
    output logic sum,
    output logic cout
);
    always @(*) begin
        sum = a ^ b;
        cout = a & b;
    end
endmodule
