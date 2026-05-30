module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    assign q = a ^ b ^ state;
    wire state_next = a ^ b;

    always @(posedge clk) begin
        state <= state_next;
    end

endmodule