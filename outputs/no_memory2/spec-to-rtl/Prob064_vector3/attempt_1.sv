module TopModule(
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    logic [31:0] concat_data;

    always @(*) begin
        // Concatenate inputs: a, b, c, d, e, f (30 bits) then two 1s (2 bits)
        // Total 32 bits
        concat_data = {a, b, c, d, e, f, 2'b11};
        
        // Split into 8-bit outputs
        {w, x, y, z} = concat_data;
    end

endmodule
