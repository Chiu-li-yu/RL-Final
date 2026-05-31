module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);
    always @(*) begin
        // K-map breakdown:
        // Rows (cd): 00, 01, 11, 10
        // Cols (ab): 00, 01, 11, 10
        // Value: 1 at (cd=00, ab=01), (cd=00, ab=10), (cd=01, ab=00), (cd=01, ab=11)
        //        (cd=11, ab=01), (cd=11, ab=10), (cd=10, ab=00), (cd=10, ab=11)
        // This is XOR: out = a ^ b ^ c ^ d
        out = a ^ b ^ c ^ d;
    end
endmodule
