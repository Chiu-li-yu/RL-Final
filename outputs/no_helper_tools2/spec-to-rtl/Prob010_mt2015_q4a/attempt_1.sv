module TopModule (
    input x,
    input y,
    output z
);

    logic z_int;

    always @(*) begin
        z_int = (x ^ y) & x;
    end

    assign z = z_int;

endmodule
