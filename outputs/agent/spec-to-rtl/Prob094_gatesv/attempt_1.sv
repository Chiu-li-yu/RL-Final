module TopModule (
    input logic [3:0] in,
    output logic [3:0] out_both,
    output logic [3:0] out_any,
    output logic [3:0] out_different
);

    always @(*) begin
        // (1) out_both: both current and left neighbour (higher index) are 1.
        // out_both[3] is unused (or 0) as it has no left neighbour.
        out_both[0] = in[0] & in[1];
        out_both[1] = in[1] & in[2];
        out_both[2] = in[2] & in[3];
        out_both[3] = 1'b0; 

        // (2) out_any: any of current and right neighbour (lower index) are 1.
        // out_any[0] is unused (or 0) as it has no right neighbour.
        out_any[0] = 1'b0;
        out_any[1] = in[1] | in[0];
        out_any[2] = in[2] | in[1];
        out_any[3] = in[3] | in[2];

        // (3) out_different: current is different from left neighbour, wrapping around.
        // in[0] neighbour is in[1], in[1] is in[2], in[2] is in[3], in[3] is in[0].
        // (Wait, the prompt says: "neighbour to the left (higher index)".
        // So for in[0], left is in[1]. For in[1], left is in[2]. For in[2], left is in[3].
        // For in[3], left is in[0] (wrap around).
        out_different[0] = in[0] ^ in[1];
        out_different[1] = in[1] ^ in[2];
        out_different[2] = in[2] ^ in[3];
        out_different[3] = in[3] ^ in[0];
    end

endmodule