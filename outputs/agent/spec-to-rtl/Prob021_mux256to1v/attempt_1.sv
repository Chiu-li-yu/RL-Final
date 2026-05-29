module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0] sel,
    output logic [3:0] out
);

    always @(*) begin
        // The multiplexer selects 4-bit blocks from the 1024-bit input.
        // For sel = 0, it selects in[3:0].
        // For sel = 1, it selects in[7:4].
        // In general, it selects in[(sel*4)+3 : sel*4].
        // We can achieve this by shifting the input vector right by (sel * 4)
        // and taking the least significant 4 bits.
        out = in >> (sel * 4);
    end

endmodule
