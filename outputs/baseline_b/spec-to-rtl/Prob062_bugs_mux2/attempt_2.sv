module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    logic [7:0] out_logic;
    assign out = out_logic;

    always @(*) begin
        if (sel) begin
            out_logic = b;
        end else begin
            out_logic = a;
        end
    end

endmodule