module TopModule (
    input logic a,
    input logic b,
    input logic c,
    output logic out
);
    // K-map table:
    // a=0, b=0, c=0 -> 0
    // a=0, b=0, c=1 -> 1
    // a=0, b=1, c=0 -> 1
    // a=0, b=1, c=1 -> 1
    // a=1, b=0, c=0 -> 1
    // a=1, b=0, c=1 -> 1
    // a=1, b=1, c=0 -> 1
    // a=1, b=1, c=1 -> 1

    // Boolean algebra: out = a | (b | c) is not quite right, let's recheck.
    // The only case it is 0 is a=0, b=0, c=0.
    // So the function is out = a | b | c.

    always @(*) begin
        out = a | b | c;
    end
endmodule
