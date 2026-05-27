module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    always @(*) begin
        // Bitwise-OR
        // Assign to out_or_bitwise
    end

    assign out_or_bitwise = a | b;

    // Logical-OR: The result of logical-OR of two vectors is 1 if any of their bits are set.
    assign out_or_logical = a || b;

    // Inverse (NOT) of both vectors.
    // Inverse of b in bits [5:3], inverse of a in bits [2:0].
    assign out_not = {~b, ~a};

endmodule
