module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    logic z_out;
    assign z_out = (A == B);
    assign z = z_out;
endmodule
