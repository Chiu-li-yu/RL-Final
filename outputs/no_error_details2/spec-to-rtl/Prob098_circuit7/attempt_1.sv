module TopModule (
    input clk,
    input a,
    output reg q
);

    initial begin
        q = 1'b1;
    end

    always @(posedge clk) begin
        q <= ~a;
    end

endmodule
