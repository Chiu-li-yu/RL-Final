module TopModule (
    input logic [1023:0] in,
    input logic [7:0] sel,
    output logic [3:0] out
);

    // 256 inputs, each is 4 bits wide. 256 * 4 = 1024.
    // The selection index `sel` ranges from 0 to 255.
    // The bits corresponding to `sel` are from `sel * 4` to `sel * 4 + 3`.
    
    always @(*) begin
        out = in[sel * 4 +: 4];
    end

endmodule
