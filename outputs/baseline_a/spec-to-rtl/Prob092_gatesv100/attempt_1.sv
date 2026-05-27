module TopModule (
    input  logic [99:0] in,
    output logic [99:0] out_both,
    output logic [99:0] out_any,
    output logic [99:0] out_different
);

    always @(*) begin
        // (1) out_both: i and its left neighbor (i+1) are both 1
        // out_both[99] is 0 as per spec.
        out_both[99] = 1'b0;
        for (int i = 0; i < 99; i++) begin
            out_both[i] = in[i] & in[i+1];
        end

        // (2) out_any: i and its right neighbor (i-1) are any 1
        // out_any[0] is 0 as per spec.
        out_any[0] = 1'b0;
        for (int i = 1; i < 100; i++) begin
            out_any[i] = in[i] | in[i-1];
        end

        // (3) out_different: i and its left neighbor (i+1) are different
        // Wrapping around: in[99]'s left neighbor is in[0]
        for (int i = 0; i < 99; i++) begin
            out_different[i] = in[i] ^ in[i+1];
        end
        out_different[99] = in[99] ^ in[0];
    end

endmodule
