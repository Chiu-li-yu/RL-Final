module TopModule (
    input clk,
    input L,
    input r_in,
    input q_in,
    output Q
);
    logic q_reg;
    logic d_in;

    // The multiplexer selects between r_in and q_in
    assign d_in = L ? r_in : q_in;

    // The flip-flop samples d_in at every clock cycle
    always_ff @(posedge clk) begin
        q_reg <= d_in;
    end

    // The current value of the flip-flop is the output Q
    assign Q = q_reg;
endmodule
