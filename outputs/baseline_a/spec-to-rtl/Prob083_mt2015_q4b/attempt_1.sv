module TopModule (
    input x,
    input y,
    output logic z
);

    always @(*) begin
        if (x == y) begin
            z = 1'b1;
        end else begin
            z = 1'b0;
        end
    end

endmodule
