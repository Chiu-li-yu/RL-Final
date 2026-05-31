module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    logic gate1;
    logic gate2;

    always @(*) begin
        gate1 = p1a & p1b & p1c & p1d;
        p1y = ~gate1;

        gate2 = p2a & p2b & p2c & p2d;
        p2y = ~gate2;
    end

endmodule
