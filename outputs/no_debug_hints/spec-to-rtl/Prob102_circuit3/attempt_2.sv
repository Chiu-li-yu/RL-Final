module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output logic q
);
    always @(*) begin
        q = (a | b) & d;
    end
endmodule
