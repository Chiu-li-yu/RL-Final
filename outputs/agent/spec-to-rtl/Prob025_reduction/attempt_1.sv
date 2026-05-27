module TopModule (
    input [7:0] in,
    output parity
);

    logic p;

    always @(*) begin
        p = ^in;
    end

    assign parity = p;

endmodule
