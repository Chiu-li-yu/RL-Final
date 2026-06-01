module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);
    logic [31:0] prev_in;
    logic [31:0] captured;

    assign out = captured;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in; // Initialize with current input to avoid false trigger on first cycle
            captured <= 32'b0;
        end else begin
            prev_in <= in;
            // The condition is: input changes from 1 (in previous cycle) to 0 (in current cycle)
            // That is: (prev_in[i] == 1) && (in[i] == 0)
            captured <= captured | (prev_in & ~in);
        end
    end
endmodule
