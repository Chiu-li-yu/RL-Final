module TopModule (
    input clk,
    input x,
    output logic z
);
    logic ff1 = 1'b0;
    logic ff2 = 1'b0;
    logic ff3 = 1'b0;

    always @(posedge clk) begin
        ff1 <= x ^ ff1;
        ff2 <= x & (!ff2);
        ff3 <= x | (!ff3);
    end

    // Z is the NOR of the flip-flop outputs
    assign z = ~(ff1 | ff2 | ff3);

endmodule