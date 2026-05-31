module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    always @(*) begin
        // The sel input is 8 bits (256 values).
        // Since in is 1024 bits and we need 4-bit chunks:
        // 1024 / 4 = 256 chunks.
        // If sel is between 0 and 255, we can select the chunk.
        // Using an indexed part select: in[sel*4 +: 4]
        if (sel < 256) begin
            out = in[sel * 4 +: 4];
        end else begin
            out = 4'b0;
        end
    end

endmodule
