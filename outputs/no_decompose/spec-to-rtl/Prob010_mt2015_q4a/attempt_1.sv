module TopModule (
    input x,
    input y,
    output z
);

    logic z_out;
    always @(*) begin
        z_out = (x ^ y) & x;
    end

    assign z = z_out;

endmodule