module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output logic [511:0] q
);

    logic [511:0] next_q;

    // Rule 110 logic implementation
    // Rule: L C R | Next
    //       1 1 1 | 0
    //       1 1 0 | 1
    //       1 0 1 | 1
    //       1 0 0 | 0
    //       0 1 1 | 1
    //       0 1 0 | 1
    //       0 0 1 | 1
    //       0 0 0 | 0
    // Expression: next = (center & ~right) | (~center & right) | (left & ~center & ~right)
    // Simplified: next = (center ^ right) | (left & ~center & right) ... wait, let's just use a case or logic.
    // Let's use Boolean algebra:
    // next = (center & !right) | (!center & right) | (left & !center & right) ... wait let me re-verify.
    // L C R -> N
    // 0 0 0 -> 0
    // 0 0 1 -> 1
    // 0 1 0 -> 1
    // 0 1 1 -> 1
    // 1 0 0 -> 0
    // 1 0 1 -> 1
    // 1 1 0 -> 1
    // 1 1 1 -> 0
    // Correct boolean logic: next = (C ^ R) | (L & ~C & R) 
    // Wait: (C ^ R) is:
    // 000 -> 0
    // 001 -> 1
    // 010 -> 1
    // 011 -> 0
    // 100 -> 0
    // 101 -> 1
    // 110 -> 1
    // 111 -> 0
    //
    // Truth table:
    // LCR | N
    // 000 | 0
    // 001 | 1
    // 010 | 1
    // 011 | 1
    // 100 | 0
    // 101 | 1
    // 110 | 1
    // 111 | 0
    
    // Using mapping directly:
    always @(*) begin
        for (int i = 0; i < 512; i++) begin
            logic left, center, right;
            center = q[i];
            right = (i == 0) ? 1'b0 : q[i-1];
            left = (i == 511) ? 1'b0 : q[i+1];
            
            // next = (left & !center & !right) | (!left & center & right) | (!left & center & !right) | (!left & !center & right) | (left & center & !right)
            // Or simpler:
            // next = (center ^ right) | (left & ~center & right) ... no
            // Let's use the truth table:
            next_q[i] = (left & center & right) ? 1'b0 :
                        (left & center & !right) ? 1'b1 :
                        (left & !center & right) ? 1'b1 :
                        (left & !center & !right) ? 1'b0 :
                        (!left & center & right) ? 1'b1 :
                        (!left & center & !right) ? 1'b1 :
                        (!left & !center & right) ? 1'b1 :
                        1'b0; // 000
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule