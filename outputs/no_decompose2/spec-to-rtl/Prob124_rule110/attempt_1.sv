module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output logic [511:0] q
);

    logic [511:0] next_q;
    integer i;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            logic left, center, right;
            
            // Boundary conditions
            left   = (i == 511) ? 0 : q[i+1];
            center = q[i];
            right  = (i == 0)   ? 0 : q[i-1];
            
            // Rule 110 logic table
            // Left | Center | Right | Next
            // 1    | 1      | 1     | 0
            // 1    | 1      | 0     | 1
            // 1    | 0      | 1     | 1
            // 1    | 0      | 0     | 0
            // 0    | 1      | 1     | 1
            // 0    | 1      | 0     | 1
            // 0    | 0      | 1     | 1
            // 0    | 0      | 0     | 0
            
            // Simplified logic:
            // next = (center & !right) | (!center & right) | (!left & center & right)
            // Wait, let's use the provided table directly to be safe:
            // next = (~left & center & right) | (~left & center & ~right) | (~left & ~center & right) | (left & center & ~right) | (left & ~center & right)
            
            next_q[i] = (left & center & ~right) |
                        (left & ~center & right) |
                        (~left & center & right) |
                        (~left & center & ~right) |
                        (~left & ~center & right);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end
endmodule
