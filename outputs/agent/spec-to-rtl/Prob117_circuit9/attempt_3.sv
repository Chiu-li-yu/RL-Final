module TopModule (
    input clk,
    input a,
    output logic [2:0] q
);

    // Initial state check from waveform:
    // At t=5ns (first clk edge), q=4.
    // If a=1 initially, q should be 4.

    always @(posedge clk) begin
        if (a) begin
            q <= 3'd4;
        end else begin
            // If it was undefined, start at 4 then increment?
            // Wait, look at the waveform again:
            // 45ns, a=0, q=4.
            // 55ns, a=0, q=5 (after rising edge).
            // So when a=0, it acts as a normal counter.
            // My previous logic seems correct, let's re-verify the input sequence in the testbench.
            q <= q + 1'b1;
        end
    end

endmodule
