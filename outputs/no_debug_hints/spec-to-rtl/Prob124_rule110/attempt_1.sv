module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output logic [511:0] q
);

    logic [511:0] next_state;
    integer i;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Rule 110 logic based on table:
            // L, C, R -> Next
            // 1, 1, 1 -> 0
            // 1, 1, 0 -> 1
            // 1, 0, 1 -> 1
            // 1, 0, 0 -> 0
            // 0, 1, 1 -> 1
            // 0, 1, 0 -> 1
            // 0, 0, 1 -> 1
            // 0, 0, 0 -> 0
            
            // Left boundary (i=511): q[512] is treated as 0
            // Right boundary (i=0): q[-1] is treated as 0
            
            logic left, center, right;
            left   = (i == 511) ? 1'b0 : q[i+1];
            center = q[i];
            right  = (i == 0)   ? 1'b0 : q[i-1];
            
            // Boolean simplification of the table:
            // Next = (C & ~R) | (~C & R) | (~L & C & R) --- Wait, let's derive properly.
            // Truth table:
            // L C R | Out
            // 1 1 1 | 0
            // 1 1 0 | 1
            // 1 0 1 | 1
            // 1 0 0 | 0
            // 0 1 1 | 1
            // 0 1 0 | 1
            // 0 0 1 | 1
            // 0 0 0 | 0
            
            // Canonical Sum of Products:
            // (~L & C & R) | (~L & C & ~R) | (~L & ~C & R) | (L & C & ~R) | (L & ~C & R)
            // = (~L & (C & R | C & ~R | ~C & R)) | (L & (C & ~R | ~C & R))
            // = (~L & (C | R)) | (L & (C ^ R))
            
            next_state[i] = (~left & (center | right)) | (left & (center ^ right));
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end
endmodule
