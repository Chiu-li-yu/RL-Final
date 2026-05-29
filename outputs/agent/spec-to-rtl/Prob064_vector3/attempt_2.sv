module TopModule (
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);
    logic [31:0] combined;

    assign combined = {a, b, c, d, e, f, 2'b11};
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];
endmodule
