module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    logic and1_p1;
    logic and2_p1;
    logic and1_p2;
    logic and2_p2;

    always @(*) begin
        and1_p1 = p1a & p1b & p1c;
        and2_p1 = p1d & p1e & p1f;
        and1_p2 = p2a & p2b;
        and2_p2 = p2c & p2d;
    end

    always @(*) begin
        p1y = and1_p1 | and2_p1;
        p2y = and1_p2 | and2_p2;
    end

endmodule
