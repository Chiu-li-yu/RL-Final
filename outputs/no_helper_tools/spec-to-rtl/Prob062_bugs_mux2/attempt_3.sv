module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    logic [7:0] val;
    assign out = val[0]; // Wait, the original bug might be the output width or bit selection?

    always @(*) begin
        if (sel)
            val = b;
        else
            val = a;
    end

endmodule
