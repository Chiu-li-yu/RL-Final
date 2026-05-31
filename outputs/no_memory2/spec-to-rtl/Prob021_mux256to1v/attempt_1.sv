module TopModule (
    input  logic [1023:0] in,
    input  logic [7:0]    sel,
    output logic [3:0]    out
);

    // The input 'in' has 1024 bits.
    // We need to select 4 bits out of 1024 bits based on 'sel'.
    // sel ranges from 0 to 255.
    // When sel = 0, we want in[3:0]
    // When sel = 1, we want in[7:4]
    // When sel = i, we want in[4*i + 3 : 4*i]

    // Use a multi-dimensional array or a simple shift-based selection.
    // Since this is a 256-to-1 multiplexer of 4-bit values:
    
    logic [3:0] mux [255:0];
    
    always @(*) begin
        // Map the 1024-bit input into an array of 256 4-bit segments
        for (int i = 0; i < 256; i = i + 1) begin
            mux[i] = in[4*i + 3 : 4*i];
        end
        
        // Select based on sel
        out = mux[sel];
    end

endmodule
