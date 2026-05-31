module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output logic [31:0] out
);
    logic [31:0] prev_in;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_in <= in;
            out <= 32'b0;
        end else begin
            // Check for falling edge (1 -> 0)
            for (int i = 0; i < 32; i = i + 1) begin
                if (prev_in[i] == 1'b1 && in[i] == 1'b0) begin
                    out[i] <= 1'b1;
                end
            end
            prev_in <= in;
        end
    end
endmodule