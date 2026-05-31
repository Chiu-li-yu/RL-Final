module TopModule (
    input a,
    input b,
    input c,
    output out
);
    assign out = a | (b & ~c) | (b & c) | (~b & c);
    // Actually simpler:
    // When a=1, out=1.
    // When a=0, out = bc + b~c + ~bc = b + c
    // So out = a | b | c
endmodule
