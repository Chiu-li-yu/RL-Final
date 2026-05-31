module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Karnaugh Map analysis:
    // a=0: (bc=01, 11, 10) -> out=1
    // a=1: (bc=00, 01, 11, 10) -> out=1
    // From K-map:
    // When a=0: out = b | c
    // When a=1: out = 1
    // Logic: out = a | (b | c) = a | b | c
    
    logic out_temp;
    always @(*) begin
        out_temp = a | b | c;
    end
    
    assign out = out_temp;
endmodule
