module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output logic [99:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            case (ena)
                2'b01: begin // Right rotate: {q[0], q[99:1]}
                    q <= {q[0], q[99:1]};
                end
                2'b10: begin // Left rotate: {q[98:0], q[99]}
                    q <= {q[98:0], q[99]};
                end
                default: begin
                    q <= q;
                end
            endcase
        end
    end

endmodule
