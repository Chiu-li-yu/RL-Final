module TopModule (
    input [99:0] in,
    output logic [99:0] out_both,
    output logic [99:0] out_any,
    output logic [99:0] out_different
);

    integer i;

    always @(*) begin
        out_both = 100'b0;
        out_any = 100'b0;
        out_different = 100'b0;

        // (1) out_both
        // out_both[99] is already 0
        for (i = 0; i < 99; i = i + 1) begin
            out_both[i] = in[i] & in[i+1];
        end

        // (2) out_any
        // out_any[0] is already 0
        for (i = 1; i < 100; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end

        // (3) out_different (wrapping)
        for (i = 0; i < 99; i = i + 1) begin
            out_different[i] = in[i] ^ in[i+1];
        end
        out_different[99] = in[99] ^ in[0];
    end

endmodule
