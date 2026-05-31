module TopModule (
    input clk,
    input a,
    output logic q
);
    logic q_next;

    always_ff @(posedge clk) begin
        q <= q_next;
    end

    always @(*) begin
        // Based on the waveform:
        // t=15ns (rising edge of clk): a=0, q becomes 1
        // t=45ns (rising edge of clk): a=1, q becomes 0
        // It looks like a flip-flop that sets q=1 when a=0, and resets to q=0 when a=1.
        // Or simply: q = ~a
        q_next = ~a;
    end
endmodule
