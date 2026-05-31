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
        // The concatenation order in Verilog is {a, b, c, d, e, f, 2'b11}
        // which puts 'a' at the MSB side.
        // If we assign {w, x, y, z} = concat_data, w is MSB.
        // Let's re-verify the concatenation sequence.
        // a=5, b=5, c=5, d=5, e=5, f=5, 2 bits = 32 bits total.
        concat_data = {a, b, c, d, e, f, 2'b11};
        {w, x, y, z} = concat_data;
    end

endmodule
