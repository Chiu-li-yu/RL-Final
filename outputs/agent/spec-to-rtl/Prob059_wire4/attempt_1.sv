module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

    always @(*) begin
        w = a;
        x = b;
        y = b;
        z = c;
    end

endmodule