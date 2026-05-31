module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output logic [99:0] q
);
    logic [99:0] q_next;

    always_ff @(posedge clk) begin
        q <= q_next;
    end

    always @(*) begin
        if (load) begin
            q_next = data;
        end else begin
            case (ena)
                2'b01: q_next = {q[0], q[99:1]};          // Rotate right
                2'b10: q_next = {q[98:0], q[99]};         // Rotate left
                default: q_next = q;                      // No rotation
            endcase
        end
    end
endmodule
