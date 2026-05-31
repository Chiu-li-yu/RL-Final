module TopModule (
    input logic [99:0] in,
    output logic [99:0] out_both,
    output logic [99:0] out_any,
    output logic [99:0] out_different
);

    always @(*) begin
        // (1) out_both: in[i] and in[i+1]
        out_both[99] = 1'b0;
        for (int i = 0; i < 99; i = i + 1) begin
            out_both[i] = in[i] & in[i+1];
        end

        // (2) out_any: in[i] or in[i-1]
        out_any[0] = 1'b0;
        for (int i = 1; i < 100; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end

        // (3) out_different: in[i] != in[left_neighbour]
        // Wrap around: in[99]'s left is in[0]
        for (int i = 0; i < 99; i = i + 1) begin
            out_different[i] = in[i] ^ in[i+1];
        end
        out_different[99] = in[99] ^ in[0];
    end

endmodule
