module TopModule(
    input clk,
    input [7:0] in,
    output logic [7:0] anyedge
);

    logic [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;
    end

    // The output should be 1 the cycle AFTER the change.
    // The current logic outputs high on the same cycle as the change detected.
    // If I need it the cycle after, I should delay the output one more clock.

    logic [7:0] next_anyedge;

    always @(*) begin
        next_anyedge = in ^ prev_in;
    end

    always @(posedge clk) begin
        anyedge <= next_anyedge;
    end

endmodule
