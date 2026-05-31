module TopModule(
    input a,
    input b,
    input c,
    output logic out
);
    always @(*) begin
        // K-map breakdown:
        // a=0, bc=00 -> 0
        // a=0, bc=01 -> 1
        // a=0, bc=11 -> 1
        // a=0, bc=10 -> 1
        // a=1, bc=00 -> 1
        // a=1, bc=01 -> 1
        // a=1, bc=11 -> 1
        // a=1, bc=10 -> 1
        
        // Logical expression from map:
        // The cell (0, 00) is 0. All other 7 cells are 1.
        // This is equivalent to an OR gate: a | b | c
        out = a | b | c;
    end
endmodule
