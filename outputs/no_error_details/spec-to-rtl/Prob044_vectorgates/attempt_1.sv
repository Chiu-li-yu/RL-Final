module TopModule (
    input logic [2:0] a,
    input logic [2:0] b,
    output logic [2:0] out_or_bitwise,
    output logic out_or_logical,
    output logic [5:0] out_not
);
    always @(*) begin
        out_or_bitwise = a | b;
        out_or_logical = a || b;
        out_not = {~b, ~a};
    end
endmodule
