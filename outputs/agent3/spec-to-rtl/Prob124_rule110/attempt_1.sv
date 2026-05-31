module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output logic [511:0] q
);

    logic [511:0] next_q;
    integer i;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            logic left, center, right;
            
            center = q[i];
            
            if (i == 511)
                left = 0;
            else
                left = q[i+1];
                
            if (i == 0)
                right = 0;
            else
                right = q[i-1];
            
            // Rule 110 Table:
            // 111 -> 0
            // 110 -> 1
            // 101 -> 1
            // 100 -> 0
            // 011 -> 1
            // 010 -> 1
            // 001 -> 1
            // 000 -> 0
            
            // Logic expression:
            // next_state = (~left & center & right) | (~left & center & ~right) | 
            //              (left & ~center & right) | (left & ~center & ~right) | 
            //              (~left & ~center & right)
            // Simplified:
            // next_q[i] = (center & ~right) | (~center & right) | (left & ~right)
            // Let's re-verify table:
            // L C R | Next
            // 1 1 1 | 0  : 1&1&1 -> 1. (center&right) = 1. (center&~right)=0, (~center&right)=0, (left&~right)=0. 
            //              Wait, 0. Expression: (C^R) | (L&~R) & C ??? No.
            
            // Let's use standard table mapping:
            // next = (center ^ right) | (left & ~center & ~right) is not quite right.
            
            // Re-evaluating:
            // 011 (3), 010 (2), 001 (1) -> 1
            // 110 (6), 101 (5) -> 1
            // 111 (7) -> 0
            // 100 (4) -> 0
            // 000 (0) -> 0
            
            // next = (center ^ right) | (left & ~center & right)? 
            // Actually: next = (center & ~right) | (~center & right) | (left & ~center & ~right) 
            // Check 111: (1&0)|(0&1)|(1&0&0) = 0. OK.
            // Check 110: (1&1)|(0&0)|(1&0&1) = 1. OK.
            // Check 101: (0&0)|(1&1)|(1&1&0) = 1. OK.
            // Check 100: (0&1)|(1&0)|(1&1&1) = 1. Wait, 100 should be 0.
            
            // Let's just use a case statement for safety:
            case ({left, center, right})
                3'b111: next_q[i] = 0;
                3'b110: next_q[i] = 1;
                3'b101: next_q[i] = 1;
                3'b100: next_q[i] = 0;
                3'b011: next_q[i] = 1;
                3'b010: next_q[i] = 1;
                3'b001: next_q[i] = 1;
                3'b000: next_q[i] = 0;
                default: next_q[i] = 0;
            endcase
        end
    end

endmodule
