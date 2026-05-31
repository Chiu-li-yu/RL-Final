module TopModule(
    input clk,
    input a,
    output logic q
);

    // Initial analysis of waveform:
    // 0ns:  q=x
    // 5ns:  a=0 -> 15ns q=1
    // 15ns: a=0 -> 25ns q=1
    // 25ns: a=0 -> 35ns q=1
    // 35ns: a=1 -> 45ns q=0 (change occurs when a=1)
    // 45ns: a=1 -> 55ns q=0 (remains 0)
    
    // Seems like:
    // If a=0, q becomes 1 (or stays 1)
    // If a=1, q flips
    
    // Let's re-examine the logic:
    // At 5ns, a=0, q becomes 1 at 15ns.
    // At 35ns, a=1, q becomes 0 at 45ns (was 1 before).
    // At 45ns, a=1, q stays 0 at 55ns.
    
    // So the rule is: q_next = a ? ~q : 1'b1;
    
    always_ff @(posedge clk) begin
        if (a)
            q <= ~q;
        else
            q <= 1'b1;
    end

endmodule
