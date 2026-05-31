module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    logic [99:0] out_both_temp;
    logic [99:0] out_any_temp;
    logic [99:0] out_different_temp;

    always @(*) begin
        // (1) out_both: in[i] and in[i+1] (for i=98..0), in[99]=0
        out_both_temp[99] = 1'b0;
        for (int i = 0; i < 99; i = i + 1) begin
            out_both_temp[i] = in[i] & in[i+1];
        end

        // (2) out_any: in[i] or in[i-1] (for i=99..1), in[0]=0
        out_any_temp[0] = 1'b0;
        for (int i = 1; i < 100; i = i + 1) begin
            out_any_temp[i] = in[i] | in[i-1];
        end

        // (3) out_different: in[i] != in[left_neighbour] (wrap around)
        // for i=99, left is 0. for i=0..98, left is i+1.
        out_different_temp[99] = in[99] ^ in[0];
        for (int i = 0; i < 99; i = i + 1) begin
            out_different_temp[i] = in[i] ^ in[i+1];
        end
    end

    assign out_both = out_both_temp;
    assign out_any = out_any_temp;
    assign out_different = out_different_temp;

endmodule
