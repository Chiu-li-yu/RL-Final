module TopModule (
    input logic [99:0] a,
    input logic [99:0] b,
    input logic sel,
    output logic [99:0] out
);

    always @(*) begin
        if (sel == 1'b0)
            out = a;
        else
            out = b;
    end

endmodule
