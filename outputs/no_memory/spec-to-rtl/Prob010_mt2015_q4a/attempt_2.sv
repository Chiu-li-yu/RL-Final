module TopModule (
    input x,
    input y,
    output z
);

    always @(*) begin
        z = (x ^ y) & x;
    end

endmodule