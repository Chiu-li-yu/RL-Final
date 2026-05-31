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
        // Concatenate inputs and append two 1s at LSB
        // 6 * 5 = 30 bits, + 2 bits = 32 bits total
        concat_data = {a, b, c, d, e, f, 2'b11};
        
        // Split into 4 outputs of 8 bits each
        {w, x, y, z} = concat_data;
    end

endmodule
