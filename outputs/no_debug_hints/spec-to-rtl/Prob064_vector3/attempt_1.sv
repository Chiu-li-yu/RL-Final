module TopModule (
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
        // Concatenate inputs and add two 1-bits at the end (LSB)
        // Total 30 bits (a-f) + 2 bits = 32 bits
        concat_data = {a, b, c, d, e, f, 2'b11};

        // Split into four 8-bit outputs
        // According to "concatenate ... followed by two 1 bits (LSB)"
        // concat_data[31:24] = w, concat_data[23:16] = x, concat_data[15:8] = y, concat_data[7:0] = z
        w = concat_data[31:24];
        x = concat_data[23:16];
        y = concat_data[15:8];
        z = concat_data[7:0];
    end

endmodule
