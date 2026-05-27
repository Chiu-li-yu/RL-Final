module TopModule (
    input logic [3:0] x,
    input logic [3:0] y,
    output logic [4:0] sum
);

    logic [4:0] carry;

    // Full Adder logic
    // Using a simple behavioral addition which is synthesized into full adders
    always @(*) begin
        sum = x + y;
    end

endmodule
