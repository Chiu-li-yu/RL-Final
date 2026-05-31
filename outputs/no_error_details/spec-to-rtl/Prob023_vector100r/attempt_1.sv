module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    integer i;
    logic [99:0] temp_out;

    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            temp_out[i] = in[99 - i];
        end
    end

    assign out = temp_out;

endmodule