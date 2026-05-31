module TopModule (
    input x,
    input y,
    output logic z
);

    always @(*) begin
        z = (x ^ y) & x;
    end

endmodule
