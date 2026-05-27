module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    logic [7:0] result;

    always @(*) begin
        if (sel) begin
            result = b;
        end else begin
            result = a;
        end
    end

    assign out = result;

endmodule
