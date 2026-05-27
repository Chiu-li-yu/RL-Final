module TopModule(
    input  x,
    input  y,
    output z
);

    logic z_internal;

    always @(*) begin
        z_internal = (x ^ y) & x;
    end

    assign z = z_internal;

endmodule
