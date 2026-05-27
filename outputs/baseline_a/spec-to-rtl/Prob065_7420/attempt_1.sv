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

    always @(*) begin
        // 7420 is a dual 4-input NAND gate
        p1y = ~(p1a & p1b & p1c & p1d);
        p2y = ~(p2a & p2b & p2c & p2d);
    end

endmodule
