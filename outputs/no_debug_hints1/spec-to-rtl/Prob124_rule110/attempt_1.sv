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
            
            // Left boundary: q[i+1], i=511 -> 0
            if (i == 511) left = 1'b0;
            else left = q[i+1];
            
            center = q[i];
            
            // Right boundary: q[i-1], i=0 -> 0
            if (i == 0) right = 1'b0;
            else right = q[i-1];
            
            // Rule 110 logic table
            // 111 -> 0
            // 110 -> 1
            // 101 -> 1
            // 100 -> 0
            // 011 -> 1
            // 010 -> 1
            // 001 -> 1
            // 000 -> 0
            
            // Simplified Rule 110: (center & !right) | (!left & center) | (!left & right)
            // Or simpler: (center ^ right) | (left & center & right) ... wait let's use lookup.
            
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
