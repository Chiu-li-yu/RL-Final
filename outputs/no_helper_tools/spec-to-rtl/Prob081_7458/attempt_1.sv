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

    logic and1_1, and1_2;
    logic and2_1, and2_2;

    always @(*) begin
        and1_1 = p1a & p1b & p1c;
        and1_2 = p1d & p1e & p1f;
        
        and2_1 = p2a & p2b;
        and2_2 = p2c & p2d;
    end

    assign p1y = and1_1 | and1_2;
    assign p2y = and2_1 | and2_2;

endmodule
