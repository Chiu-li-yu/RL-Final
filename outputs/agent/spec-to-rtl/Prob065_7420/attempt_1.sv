module TopModule(
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

    logic gate1_out;
    logic gate2_out;

    always @(*) begin
        gate1_out = ~(p1a & p1b & p1c & p1d);
        gate2_out = ~(p2a & p2b & p2c & p2d);
    end

    assign p1y = gate1_out;
    assign p2y = gate2_out;

endmodule
