module TopModule (
    input logic [3:0] in,
    output logic [3:0] out_both,
    output logic [3:0] out_any,
    output logic [3:0] out_different
);

    always @(*) begin
        // out_both: in[i] and its neighbor to the left (higher index)
        // out_both[2] = in[2] && in[3]
        // out_both[1] = in[1] && in[2]
        // out_both[0] = in[0] && in[1]
        // out_both[3] is undefined (don't need to know)
        out_both[0] = in[0] && in[1];
        out_both[1] = in[1] && in[2];
        out_both[2] = in[2] && in[3];
        out_both[3] = 0; // Padding

        // out_any: in[i] or its neighbor to the right (lower index)
        // out_any[2] = in[2] || in[1]
        // out_any[1] = in[1] || in[0]
        // out_any[3] = in[3] || in[2]
        // out_any[0] is undefined
        out_any[0] = 0; // Padding
        out_any[1] = in[1] || in[0];
        out_any[2] = in[2] || in[1];
        out_any[3] = in[3] || in[2];

        // out_different: in[i] different from neighbor to left (wrapping around)
        // in[3]'s neighbor to the left is in[0]
        // out_different[3] = in[3] ^ in[0]
        // out_different[2] = in[2] ^ in[3]
        // out_different[1] = in[1] ^ in[2]
        // out_different[0] = in[0] ^ in[1]
        out_different[0] = in[0] ^ in[1];
        out_different[1] = in[1] ^ in[2];
        out_different[2] = in[2] ^ in[3];
        out_different[3] = in[3] ^ in[0];
    end
endmodule