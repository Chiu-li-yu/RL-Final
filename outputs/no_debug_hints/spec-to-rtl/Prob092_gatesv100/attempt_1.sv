module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    integer i;

    always @(*) begin
        // (1) out_both: 1 if in[i] and in[i+1] are 1. out_both[99] = 0.
        for (i = 0; i < 99; i = i + 1) begin
            out_both[i] = in[i] & in[i+1];
        end
        out_both[99] = 1'b0;

        // (2) out_any: 1 if in[i] or in[i-1] are 1. out_any[0] = 0.
        for (i = 1; i < 100; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end
        out_any[0] = 1'b0;

        // (3) out_different: 1 if in[i] != in[left_neighbor]. 
        // Wrapping: in[99]'s left is in[0].
        // For i < 99, left is i+1. For i = 99, left is 0.
        for (i = 0; i < 99; i = i + 1) begin
            out_different[i] = in[i] ^ in[i+1];
        end
        out_different[99] = in[99] ^ in[0];
    end

endmodule
