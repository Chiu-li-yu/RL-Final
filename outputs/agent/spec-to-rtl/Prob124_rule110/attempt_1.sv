module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    integer i;
    logic [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            logic left, center, right;
            
            // Handle boundaries (q[-1] and q[512] are 0)
            left   = (i == 511) ? 1'b0 : q[i+1];
            center = q[i];
            right  = (i == 0)   ? 1'b0 : q[i-1];
            
            // Rule 110 logic table:
            // 111 -> 0
            // 110 -> 1
            // 101 -> 1
            // 100 -> 0
            // 011 -> 1
            // 010 -> 1
            // 001 -> 1
            // 000 -> 0
            // Simplified boolean expression for Rule 110:
            // Center' = (Center ^ Right) | (~Left & Center & Right) | (~Left & Center & ~Right) | (~Left & ~Center & Right)
            // Actually, Rule 110 is: (Center ^ Right) | (Center & ~Right) ... wait, let's just use the table
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
