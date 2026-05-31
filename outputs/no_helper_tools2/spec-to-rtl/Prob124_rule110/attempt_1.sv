module TopModule(
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
            
            center = q[i];
            left   = (i == 511) ? 1'b0 : q[i+1];
            right  = (i == 0)   ? 1'b0 : q[i-1];
            
            // Rule 110:
            // 111 -> 0
            // 110 -> 1
            // 101 -> 1
            // 100 -> 0
            // 011 -> 1
            // 010 -> 1
            // 001 -> 1
            // 000 -> 0
            // Result is (center & ~right) | (~center & right) | (left & ~center)
            // Simplified logic: (left & ~center & ~right) | (left & center & ~right) | (~left & center & right) | (~left & center & ~right) | (~left & ~center & right)
            // Actually Rule 110 truth table simplifies to: next = (center ^ right) | (left & ~center & right) ... no, let's use the table directly.
            
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

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
