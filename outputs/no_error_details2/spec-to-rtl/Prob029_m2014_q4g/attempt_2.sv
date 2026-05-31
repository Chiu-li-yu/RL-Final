module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

    logic xnor_out;
    
    // XNOR truth table: 
    // 0,0 -> 1
    // 0,1 -> 0
    // 1,0 -> 0
    // 1,1 -> 1
    
    // XOR truth table:
    // 0,0 -> 0
    // 0,1 -> 1
    // 1,0 -> 1
    // 1,1 -> 0

    always @(*) begin
        xnor_out = (in1 ~^ in2);
        out = xnor_out ^ in3;
    end

endmodule
