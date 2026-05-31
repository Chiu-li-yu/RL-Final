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

    // Concatenate all inputs + two 1s
    // Total bits = 5+5+5+5+5+5 + 2 = 32
    // Concatenation order: {a, b, c, d, e, f, 2'b11}
    // Result bit sequence:
    // a[4:0] | b[4:0] | c[4:0] | d[4:0] | e[4:0] | f[4:0] | 1 | 1
    
    logic [31:0] full_vec;

    always @(*) begin
        full_vec = {a, b, c, d, e, f, 2'b11};
        
        // Output concatenation: {w, x, y, z} = full_vec
        w = full_vec[31:24];
        x = full_vec[23:16];
        y = full_vec[15:8];
        z = full_vec[7:0];
    end

endmodule
