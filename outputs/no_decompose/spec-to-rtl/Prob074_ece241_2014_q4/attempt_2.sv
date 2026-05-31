module TopModule(
    input clk,
    input x,
    output z
);
    logic q_xor, q_and, q_or;
    logic d_xor, d_and, d_or;
    logic rst_n = 1'b0; // Internal reset handling

    // The specification says "Assume that the D flip-flops are initially reset to zero"
    // We use a reset signal to initialize them. Since reset is not provided as an input,
    // we use a logic that defaults to 0 and behaves like a reset.
    // In Verilog, variables initialized to 0 behave as such after reset.
    
    // Updated flip-flops with synchronous reset behavior
    always_ff @(posedge clk) begin
        if (rst_n == 1'b0) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
            rst_n <= 1'b1;
        end else begin
            q_xor <= x ^ q_xor;
            q_and <= x & (~q_and);
            q_or  <= x | (~q_or);
        end
    end

    assign z = ~(q_xor | q_and | q_or);
endmodule