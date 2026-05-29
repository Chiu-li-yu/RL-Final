module TopModule (
    input clk,
    input a,
    input b,
    output logic out_assign,
    output logic out_always_comb,
    output logic out_always_ff
);

    // Method 1: XOR using an assign statement
    assign out_assign = a ^ b;

    // Method 2: XOR using a combinational always block
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Method 3: XOR using a clocked always block (sequential logic)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
