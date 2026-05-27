module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    logic [7:0] out_logic;

    always @(*) begin
        if (sel)
            out_logic = b;
        else
            out_logic = a;
    end

    assign out = out_logic;

endmodule