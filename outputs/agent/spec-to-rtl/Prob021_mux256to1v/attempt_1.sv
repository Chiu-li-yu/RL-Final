module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);
    // 256 inputs, each is 4 bits wide. 256 * 4 = 1024.
    // The select signal is 8 bits (up to 255), so we can select any of the 256 inputs.
    
    // We can interpret the input as an array of 256 elements, each 4 bits wide.
    logic [3:0] inputs [0:255];
    
    // Unpack the 1024-bit input into an array of 256 4-bit vectors.
    always @(*) begin
        for (int i = 0; i < 256; i = i + 1) begin
            inputs[i] = in[i*4 +: 4];
        end
    end
    
    // Select the appropriate 4-bit chunk based on sel.
    always @(*) begin
        if (sel < 256) begin
            out = inputs[sel];
        end else begin
            out = 4'b0000;
        end
    end
    
endmodule
