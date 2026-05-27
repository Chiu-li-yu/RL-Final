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
            logic left;
            logic center;
            logic right;

            center = q[i];
            left   = (i == 511) ? 1'b0 : q[i+1];
            right  = (i == 0)   ? 1'b0 : q[i-1];

            // Rule 110 logic table:
            // L C R | Next
            // 1 1 1 | 0
            // 1 1 0 | 1
            // 1 0 1 | 1
            // 1 0 0 | 0
            // 0 1 1 | 1
            // 0 1 0 | 1
            // 0 0 1 | 1
            // 0 0 0 | 0
            
            // Simplified boolean expression for Rule 110:
            // next = (C & ~R) | (~C & R) | (~L & C & R)
            // Or simpler: (C ^ R) | (L & ~C & R)
            // Let's verify with the table:
            // 111: (1^1) | (1&0&1) = 0 | 0 = 0 (Match)
            // 110: (1^0) | (1&0&0) = 1 | 0 = 1 (Match)
            // 101: (0^1) | (1&1&1) = 1 | 1 = 1 (Match)
            // 100: (0^0) | (1&1&0) = 0 | 0 = 0 (Match)
            // 011: (1^1) | (0&0&1) = 0 | 0 = 0 ... wait table says 011 is 1
            // My simplification was wrong. Let's use standard table mapping:
            
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

    always_ff @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
