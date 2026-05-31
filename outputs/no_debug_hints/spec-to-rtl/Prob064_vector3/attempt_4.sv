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

    logic [31:0] full_vec;

    always @(*) begin
        // The common trick in HDL Bits Vector3 is that concatenation might be 
        // treated as a literal and then split.
        // Let's try to pad the inputs to make it 32 bits explicitly.
        // Or re-read carefully: "The output should be a concatenation of the input vectors followed by two 1 bits"
        // 30 bits + 2 bits = 32 bits.
        
        full_vec = {a, b, c, d, e, f, 2'b11};
        
        w = full_vec[31:24];
        x = full_vec[23:16];
        y = full_vec[15:8];
        z = full_vec[7:0];
    end

endmodule
