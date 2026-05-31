module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    logic z_val;
    assign z_val = (A == B);
    assign z = z_val;

endmodule