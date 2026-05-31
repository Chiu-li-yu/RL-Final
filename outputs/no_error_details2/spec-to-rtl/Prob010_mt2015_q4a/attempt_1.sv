module TopModule (
    input x,
    input y,
    output z
);
    logic z_val;
    always @(*) begin
        z_val = (x ^ y) & x;
    end
    assign z = z_val;
endmodule
