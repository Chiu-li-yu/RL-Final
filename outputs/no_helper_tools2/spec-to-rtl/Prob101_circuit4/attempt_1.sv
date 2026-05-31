module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    logic q_internal;
    always @(*) begin
        // Observation: 
        // q is 1 if (b or c) is true.
        // If b=0 and c=0, then q is 0.
        // Let's check:
        // b=0, c=0: 0, 0, 0, 0, 0, 0, 0, 0 (q=0)
        // b=0, c=1: 1, 1, 1, 1, 1, 1 (q=1)
        // b=1, c=0: 1, 1, 1, 1, 1, 1 (q=1)
        // b=1, c=1: 1, 1, 1, 1 (q=1)
        q_internal = b | c;
    end
    assign q = q_internal;
endmodule
