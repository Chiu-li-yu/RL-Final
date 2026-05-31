module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output logic [31:0] out
);

    logic [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= in;
        end else begin
            prev_in <= in;
            for (integer i = 0; i < 32; i = i + 1) begin
                if (prev_in[i] && !in[i]) begin
                    out[i] <= 1'b1;
                end
            end
        end
    end

endmodule
