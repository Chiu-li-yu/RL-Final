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

    // Concatenate {a, b, c, d, e, f, 2'b11} = 32 bits
    // The requirement says w, x, y, z are 8 bits.
    // If {w, x, y, z} = {a, b, c, d, e, f, 2'b11}, 
    // it implies w=[31:24], x=[23:16], y=[15:8], z=[7:0]
    // Let's try reversing the order of concatenation if necessary, 
    // but usually {a, b, c...} is the standard.
    
    // Maybe the order is {f, e, d, c, b, a, 2'b11}? 
    // Let's try the simplest concatenation order first again but with 
    // explicit assignment.
    
    always @(*) begin
        w = {a, b[4:2]};
        x = {b[1:0], c, d[4]};
        y = {d[3:0], e[4:1]};
        z = {e[0], f, 2'b11};
    end

endmodule
