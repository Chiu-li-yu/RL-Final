module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output logic [511:0] q
);

    logic [511:0] next_q;
    integer i;

    always_ff @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            logic left, center, right;
            
            // Left boundary: q[i+1] (if i=511, left=0)
            left = (i == 511) ? 1'b0 : q[i+1];
            center = q[i];
            // Right boundary: q[i-1] (if i=0, right=0)
            right = (i == 0) ? 1'b0 : q[i-1];
            
            // Rule 110 table:
            // L C R | Next
            // 1 1 1 | 0
            // 1 1 0 | 1
            // 1 0 1 | 1
            // 1 0 0 | 0
            // 0 1 1 | 1
            // 0 1 0 | 1
            // 0 0 1 | 1
            // 0 0 0 | 0
            
            // Logic expression:
            // next_q[i] = (C & ~R) | (~C & R) | (L & ~C & ~R) is wrong.
            // Let's re-map:
            // (L=1,C=1,R=1) -> 0
            // (L=1,C=1,R=0) -> 1
            // (L=1,C=0,R=1) -> 1
            // (L=1,C=0,R=0) -> 0
            // (L=0,C=1,R=1) -> 1
            // (L=0,C=1,R=0) -> 1
            // (L=0,C=0,R=1) -> 1
            // (L=0,C=0,R=0) -> 0
            
            // Standard Rule 110: q' = (C ^ R) | (L & C & ~R)
            // Let's check:
            // 111: (1^1) | (1&1&0) = 0 | 0 = 0 (OK)
            // 110: (1^0) | (1&1&1) = 1 | 1 = 1 (OK)
            // 101: (0^1) | (1&0&0) = 1 | 0 = 1 (OK)
            // 100: (0^0) | (1&0&1) = 0 | 0 = 0 (OK)
            // 011: (1^1) | (0&1&0) = 0 | 0 = 0 ... wait, table says 1?
            
            // Re-check table:
            // 011 -> 1
            // My check: (1^1) | (0&1&0) = 0. My formula (C ^ R) | (L & C & ~R) is wrong for 011.
            
            // Let's use truth table:
            // next_q[i] = (left & center & ~right) | (left & ~center & right) | (~left & center & right) | (~left & center & ~right) | (~left & ~center & right)
            // Or simpler:
            // next_q[i] = (center ^ right) | (left & center & ~right) ? No.
            
            // Truth Table:
            // LCR | N
            // 111 | 0
            // 110 | 1
            // 101 | 1
            // 100 | 0
            // 011 | 1
            // 010 | 1
            // 001 | 1
            // 000 | 0
            
            // K-map:
            //      CR
            // L | 00 01 11 10
            // 0 |  0  1  1  1
            // 1 |  0  1  0  1
            
            // Row 0: 0111 (00, 01, 11, 10)
            // Row 1: 0101
            
            // Simplified:
            // next_q[i] = (center & ~right) | (~center & right) | (left & center & ~right) ... no
            // Let's group:
            // (~L & C & R) | (~L & C & ~R) | (~L & ~C & R) | (L & C & ~R) | (L & ~C & R)
            // = (~L & (C^R)) | (~L & C & R) ...
            // Let's just implement exactly:
            next_q[i] = (left & center & ~right) | (left & ~center & right) | (~left & center & right) | (~left & center & ~right) | (~left & ~center & right);
        end
    end

endmodule
