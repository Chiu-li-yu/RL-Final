module TopModule (
    input logic clk,
    input logic d,
    output logic q
);
    logic q1, q2;

    // First latch captures data on positive edge of clk
    always @(*) begin
        if (clk)
            q1 = d;
    end

    // Second latch captures data on negative edge of clk
    always @(*) begin
        if (!clk)
            q2 = d;
    end

    // MUX to select between latched data based on clock edge
    always @(*) begin
        if (clk)
            q = q1;
        else
            q = q2;
    end
endmodule
