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
            
            // Left boundary is index 511, but Rule 110 says q[-1] is 0 and q[512] is 0
            // Mapping: Left is q[i+1], Center is q[i], Right is q[i-1]
            left   = (i == 511) ? 1'b0 : q[i+1];
            center = q[i];
            right  = (i == 0)   ? 1'b0 : q[i-1];

            // Table:
            // L C R | Next
            // 1 1 1 | 0
            // 1 1 0 | 1
            // 1 0 1 | 1
            // 1 0 0 | 0
            // 0 1 1 | 1
            // 0 1 0 | 1
            // 0 0 1 | 1
            // 0 0 0 | 0
            
            // Boolean logic: (L & C & ~R) | (L & ~C & R) | (~L & C & R) | (~L & C & ~R) | (~L & ~C & R)
            // Simplified: (C & ~R) | (~C & R) | (L & ~C)
            // Let's verify:
            // 111: (1&0)|(0&1)|(1&0) = 0
            // 110: (1&1)|(0&0)|(1&0) = 1
            // 101: (0&0)|(1&1)|(1&1) = 1
            // 100: (0&1)|(1&0)|(1&1) = 1 -> WAIT, table says 0. Re-check.
            
            // Re-evaluating table:
            // 111 -> 0
            // 110 -> 1
            // 101 -> 1
            // 100 -> 0
            // 011 -> 1
            // 010 -> 1
            // 001 -> 1
            // 000 -> 0
            
            // Canonical Sum of Products:
            // next = (L&C&!R) | (L&!C&R) | (!L&C&R) | (!L&C&!R) | (!L&!C&R)
            // next = (L & (C ^ R)) | (!L & (C | R))
            
            next_q[i] = (left & (center ^ right)) | (~left & (center | right));
        end
    end

endmodule
