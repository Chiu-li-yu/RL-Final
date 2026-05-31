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
            // neighbors: left is q[i+1], center is q[i], right is q[i-1]
            // boundary conditions: q[512] = 0, q[-1] = 0
            logic left, center, right;
            
            left = (i == 511) ? 1'b0 : q[i+1];
            center = q[i];
            right = (i == 0) ? 1'b0 : q[i-1];

            // Rule 110 truth table:
            // 111 -> 0
            // 110 -> 1
            // 101 -> 1
            // 100 -> 0
            // 011 -> 1
            // 010 -> 1
            // 001 -> 1
            // 000 -> 0
            // Formula: next_state = (~left & center & right) | (~left & center & ~right) | (left & ~center & right) | (left & ~center & ~right) | (~left & ~center & right)
            // Simplified: (center & ~right) | (~center & right) | (left & ~center & right) ...
            // Let's use the actual table logic
            case ({left, center, right})
                3'b111: next_q[i] = 1'b0;
                3'b110: next_q[i] = 1'b1;
                3'b101: next_q[i] = 1'b1;
                3'b100: next_q[i] = 1'b0;
                3'b011: next_q[i] = 1'b1;
                3'b010: next_q[i] = 1'b1;
                3'b001: next_q[i] = 1'b1;
                3'b000: next_q[i] = 1'b0;
                default: next_q[i] = 1'b0;
            endcase
        end
    end

endmodule
