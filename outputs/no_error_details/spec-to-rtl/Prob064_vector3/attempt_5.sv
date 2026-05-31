module TopModule(
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);
    logic [31:0] combined;

    // Concatenate {a, b, c, d, e, f} from MSB to LSB, then 2'b11
    // combined = {a, b, c, d, e, f, 2'b11};
    // Split into {w, x, y, z}
    
    always @(*) begin
        combined = {a, b, c, d, e, f, 2'b11};
        w = combined[31:24];
        x = combined[23:16];
        y = combined[15:8];
        z = combined[7:0];
    end
endmodule
