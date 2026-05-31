module TopModule (
    input logic [7:0] a,
    input logic [7:0] b,
    input logic [7:0] c,
    input logic [7:0] d,
    output logic [7:0] min
);

    logic [7:0] min1, min2;

    always @(*) begin
        min1 = (a < b) ? a : b;
        min2 = (c < d) ? c : d;
        min  = (min1 < min2) ? min1 : min2;
    end

endmodule
