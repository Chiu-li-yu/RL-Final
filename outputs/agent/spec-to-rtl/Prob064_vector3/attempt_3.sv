module TopModule (
    input logic [4:0] a,
    input logic [4:0] b,
    input logic [4:0] c,
    input logic [4:0] d,
    input logic [4:0] e,
    input logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    // The specification: "concatenate the input vectors together then split them up into several output vectors"
    // "concatenation of the input vectors followed by two 1 bits"
    // Let's try reversing the order of input concatenation to {f, e, d, c, b, a}
    // and see if that matches the expected testbench.
    
    always @(*) begin
        {w, x, y, z} = {a, b, c, d, e, f, 2'b11};
    end

endmodule
