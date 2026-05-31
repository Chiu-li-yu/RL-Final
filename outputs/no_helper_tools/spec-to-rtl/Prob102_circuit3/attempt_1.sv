module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Truth table analysis:
    // When a=0, b=0: q=0
    // When a=0, b=1: q = c | d (for c,d combination 0,0->0; 0,1->1; 1,0->1; 1,1->1)
    // When a=1, b=0: q = c | d
    // When a=1, b=1: q = c | d
    // Simplified logic: q = (a | b) & (c | d)

    logic q_internal;
    always @(*) begin
        q_internal = (a | b) & (c | d);
    end
    assign q = q_internal;
endmodule