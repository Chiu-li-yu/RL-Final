module TopModule (
    input logic clk,
    input logic in,
    output logic out
);

    // According to the specification:
    // A D flip-flop takes as input the output of a two-input XOR.
    // The XOR takes as input 'in' along with the output 'out' of the flip-flop.
    // This implies that the D input of the flip-flop is (in ^ out).
    // Therefore, the flip-flop's value updates to (in ^ current_out) at every clock edge.

    // Using an internal register to store the state of the D Flip-Flop.
    logic state;

    // Output 'out' is the output of the flip-flop.
    assign out = state;

    // On the positive edge of clk, update the flip-flop state.
    // Since there is no reset, we just assign the next state.
    always_ff @(posedge clk) begin
        state <= in ^ out;
    end

endmodule
