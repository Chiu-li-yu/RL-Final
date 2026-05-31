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
            // neighbors: L = q[i+1], C = q[i], R = q[i-1]
            // Boundaries: q[512] = 0, q[-1] = 0
            logic L, C, R;
            L = (i == 511) ? 1'b0 : q[i+1];
            C = q[i];
            R = (i == 0) ? 1'b0 : q[i-1];

            // Rule 110 Table:
            // LCR | Next
            // 111 | 0
            // 110 | 1
            // 101 | 1
            // 100 | 0
            // 011 | 1
            // 010 | 1
            // 001 | 1
            // 000 | 0
            
            // Simplified Boolean Expression for Rule 110:
            // next_state = (C ^ R) | (L & ~C & R) ? -- wait, let's just use case.
            case ({L, C, R})
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
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule
