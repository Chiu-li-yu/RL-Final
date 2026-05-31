module TopModule (
    input x,
    input y,
    output z
);

    logic z_val;
    assign z_val = (x ^ y) & x;
    assign z = z_val;

endmodule
