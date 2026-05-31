module TopModule (
    input [99:0] in,
    output logic [99:0] out_both,
    output logic [99:0] out_any,
    output logic [99:0] out_different
);

    always @(*) begin
        // (1) out_both: in[i] and in[i+1] (for i=99, out_both[99]=0)
        out_both[99] = 1'b0;
        for (int i = 0; i < 99; i = i + 1) begin
            out_both[i] = in[i] & in[i+1];
        end

        // (2) out_any: in[i] or in[i-1] (for i=0, out_any[0]=0)
        out_any[0] = 1'b0;
        for (int i = 1; i < 100; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end

        // (3) out_different: in[i] XOR in[i+1] (wrap around: in[99] XOR in[0])
        for (int i = 0; i < 99; i = i + 1) begin
            out_different[i] = in[i] ^ in[i+1];
        end
        out_different[99] = in[99] ^ in[0];
    end

endmodule
