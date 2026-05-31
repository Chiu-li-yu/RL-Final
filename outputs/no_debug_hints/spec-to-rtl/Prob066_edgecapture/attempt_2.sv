module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);
    logic [31:0] prev_in;
    logic [31:0] captured;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end else begin
            prev_in <= in;
            for (int i = 0; i < 32; i++) begin
                if (prev_in[i] == 1'b1 && in[i] == 1'b0) begin
                    captured[i] <= 1'b1;
                end
            end
        end
    end

    assign out = captured;
endmodule