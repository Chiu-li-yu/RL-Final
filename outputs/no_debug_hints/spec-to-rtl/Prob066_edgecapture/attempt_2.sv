module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output logic [31:0] out
);
    logic [31:0] prev_in;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_in <= in; // Initialize to current input to avoid false triggers
            out <= 32'b0;
        end else begin
            prev_in <= in;
            for (int i = 0; i < 32; i = i + 1) begin
                if (prev_in[i] == 1'b1 && in[i] == 1'b0) begin
                    out[i] <= 1'b1;
                end
            end
        end
    end
endmodule