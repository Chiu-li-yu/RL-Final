module TopModule (
    input  a,
    input  b,
    input  c,
    output logic w,
    output logic x,
    output logic y,
    output logic z
);

always @(*) begin
    w = a;
    x = b;
    y = b;
    z = c;
end

endmodule