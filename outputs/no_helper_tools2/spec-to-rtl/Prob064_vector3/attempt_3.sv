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

    logic [31:0] val;

    always @(*) begin
        // The spec: concatenation of input vectors followed by two 1 bits
        // {a, b, c, d, e, f, 2'b11}
        // Result is 32 bits. 
        // Mapping:
        // w = {a, b[4:2]}
        // x = {b[1:0], c, d[4]}
        // y = {d[3:0], e[4:1]}
        // z = {e[0], f, 2'b11}
        
        val = {a, b, c, d, e, f, 2'b11};
        w = val[31:24];
        x = val[23:16];
        y = val[15:8];
        z = val[7:0];
    end

endmodule
