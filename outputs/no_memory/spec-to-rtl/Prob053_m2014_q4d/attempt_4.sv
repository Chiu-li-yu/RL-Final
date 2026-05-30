module TopModule (
    input logic clk,
    input logic in,
    output logic out
);
    logic next_out;

    // XOR 邏輯: out = in ^ out (in the next cycle)
    always_comb begin
        next_out = in ^ out;
    end

    // D flip-flop
    always_ff @(posedge clk) begin
        out <= next_out;
    end
endmodule