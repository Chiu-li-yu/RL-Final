module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    logic [7:0] result;
    assign out = result;

    always @(*) begin
        if (sel)
            result = b;
        else
            result = a;
    end

endmodule
