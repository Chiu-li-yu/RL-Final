module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    logic [511:0] next_q;
    integer i;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            logic left, center, right;
            
            // Left boundary: q[i+1] (if i=511, q[512] is 0)
            if (i == 511) left = 0;
            else left = q[i+1];
            
            center = q[i];
            
            // Right boundary: q[i-1] (if i=0, q[-1] is 0)
            if (i == 0) right = 0;
            else right = q[i-1];
            
            // Rule 110 logic:
            // 111 -> 0
            // 110 -> 1
            // 101 -> 1
            // 100 -> 0
            // 011 -> 1
            // 010 -> 1
            // 001 -> 1
            // 000 -> 0
            // This is equivalent to: (center & !right) | (!center & right) | (!left & center & right)
            // Simplified: (left & center & !right) | (center ^ right)
            // Wait, let's recheck the table.
            // L C R | Next
            // 1 1 1 | 0
            // 1 1 0 | 1
            // 1 0 1 | 1
            // 1 0 0 | 0
            // 0 1 1 | 1
            // 0 1 0 | 1
            // 0 0 1 | 1
            // 0 0 0 | 0
            
            // Equation: Next = (center & !right) | (!center & right) | (left & !center & right)  -- incorrect check
            // Correct expression for Rule 110: (center ^ right) | (left & center & !right) -- let's test
            // 111: (1^1) | (1&1&0) = 0 | 0 = 0 (Correct)
            // 110: (1^0) | (1&1&1) = 1 | 1 = 1 (Correct)
            // 101: (0^1) | (1&0&0) = 1 | 0 = 1 (Correct)
            // 100: (0^0) | (1&0&1) = 0 | 0 = 0 (Correct)
            // 011: (1^1) | (0&1&0) = 0 | 0 = 0 (Wait, table says 011 is 1)
            
            // Let's use the full sum-of-products:
            // (110) + (101) + (011) + (010) + (001)
            // = (left & center & !right) | (left & !center & right) | (!left & center & right) | (!left & center & !right) | (!left & !center & right)
            
            next_q[i] = (left & center & !right) | (left & !center & right) | (!left & center & right) | (!left & center & !right) | (!left & !center & right);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
