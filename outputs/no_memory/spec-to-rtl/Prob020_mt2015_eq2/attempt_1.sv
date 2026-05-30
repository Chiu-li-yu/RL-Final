module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    logic res;

    always @(*) begin
        if (A == B) begin
            res = 1'b1;
        end else begin
            res = 1'b0;
        end
    end

    assign z = res;

endmodule
