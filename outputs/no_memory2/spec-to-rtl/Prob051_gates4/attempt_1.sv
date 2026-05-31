module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    always @(*) begin
        // Implement 4-input AND
        // logic is implicitly continuous assignment behavior in always block
    end
    
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule