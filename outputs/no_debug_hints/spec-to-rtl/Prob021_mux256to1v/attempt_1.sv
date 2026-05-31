module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    // 256 inputs, each is 4 bits wide. 
    // sel is 8 bits (range 0-255).
    // The bits are packed as in[3:0], in[7:4], in[11:8], etc.
    // This can be treated as a 256-element array of 4-bit vectors.

    logic [3:0] data_array [0:255];

    always @(*) begin
        // Split the 1024-bit input into 256 4-bit chunks
        for (int i = 0; i < 256; i = i + 1) begin
            data_array[i] = in[i*4 +: 4];
        end
        
        // Select based on sel
        // Ensure sel is within bounds [0:255]
        if (sel < 256) begin
            out = data_array[sel];
        end else begin
            out = 4'b0;
        end
    end

endmodule