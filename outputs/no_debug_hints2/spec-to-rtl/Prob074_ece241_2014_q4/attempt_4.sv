module TopModule (
    input clk,
    input x,
    output logic z
);
    logic ff1 = 1'b0;
    logic ff2 = 1'b0;
    logic ff3 = 1'b0;
    logic d1, d2, d3;

    always @(*) begin
        d1 = x ^ ff1;
        d2 = x & (~ff2);
        d3 = x | (~ff3);
    end

    always @(posedge clk) begin
        ff1 <= d1;
        ff2 <= d2;
        ff3 <= d3;
    end

    always @(*) begin
        z = ~(ff1 | ff2 | ff3);
    end
endmodule