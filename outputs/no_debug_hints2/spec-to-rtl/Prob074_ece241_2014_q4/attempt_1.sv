module TopModule (
    input logic clk,
    input logic rst,
    input logic x,
    output logic z
);
    logic ff1, ff2, ff3;
    logic d1, d2, d3;

    always @(posedge clk) begin
        if (rst) begin
            ff1 <= 1'b0;
            ff2 <= 1'b0;
            ff3 <= 1'b0;
        end else begin
            ff1 <= d1;
            ff2 <= d2;
            ff3 <= d3;
        end
    end

    always @(*) begin
        d1 = x ^ ff1;
        d2 = x & (~ff2);
        d3 = x | (~ff3);
        z = ~(ff1 | ff2 | ff3);
    end
endmodule