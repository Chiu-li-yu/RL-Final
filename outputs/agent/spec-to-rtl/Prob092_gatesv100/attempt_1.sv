module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    logic [99:0] out_both_int;
    logic [99:0] out_any_int;
    logic [99:0] out_different_int;

    always @(*) begin
        // (1) out_both: in[i] and in[i+1]
        out_both_int[99] = 1'b0;
        for (int i = 0; i < 99; i = i + 1) begin
            out_both_int[i] = in[i] & in[i+1];
        end

        // (2) out_any: in[i] or in[i-1]
        out_any_int[0] = 1'b0;
        for (int i = 1; i < 100; i = i + 1) begin
            out_any_int[i] = in[i] | in[i-1];
        end

        // (3) out_different: in[i] ^ in[left_neighbour]
        // Wrap around: in[99]'s left is in[0]
        for (int i = 0; i < 99; i = i + 1) begin
            out_different_int[i] = in[i] ^ in[i+1];
        end
        out_different_int[99] = in[99] ^ in[0];
    end

    assign out_both = out_both_int;
    assign out_any = out_any_int;
    assign out_different = out_different_int;

endmodule
