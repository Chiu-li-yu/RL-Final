module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    logic z_out;

    always @(*) begin
        if (A == B) begin
            z_out = 1'b1;
        end else begin
            z_out = 1'b0;
        end
    end

    assign z = z_out;

endmodule
