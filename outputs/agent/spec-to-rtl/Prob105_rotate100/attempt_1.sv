module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output logic [99:0] q
);

    logic [99:0] next_q;

    always @(*) begin
        if (load) begin
            next_q = data;
        end else begin
            case (ena)
                2'b01: begin // Rotate Right
                    next_q = {q[0], q[99:1]};
                end
                2'b10: begin // Rotate Left
                    next_q = {q[98:0], q[99]};
                end
                default: begin // 2'b00 or 2'b11
                    next_q = q;
                end
            endcase
        end
    end

    always_ff @(posedge clk) begin
        q <= next_q;
    end

endmodule
