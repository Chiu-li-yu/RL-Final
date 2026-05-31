module TopModule (
    input x,
    input y,
    output z
);
    // Analysis of the waveform:
    // x=0, y=0 => z=1
    // x=1, y=0 => z=0
    // x=0, y=1 => z=0
    // x=1, y=1 => z=1
    // This is equivalent to XNOR (x == y)
    
    assign z = ~(x ^ y);
endmodule
