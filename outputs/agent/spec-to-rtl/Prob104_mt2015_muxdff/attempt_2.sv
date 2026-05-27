module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);
    logic q_reg;
    logic d_in;

    // Use a MUX to select between r_in (if L=1) or q_in (if L=0)
    assign d_in = L ? r_in : q_in;

    // Synchronous D Flip-Flop
    always_ff @(posedge clk) begin
        q_reg <= d_in;
    end

    assign Q = q_reg;
endmodule
