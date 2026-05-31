module TopModule (
    input clock,
    input a,
    output logic p,
    output logic q
);

    // Re-evaluating p and q based on the table
    // 90ns: clock=1, a=1, p=1, q=0
    // 100ns: clock=1, a=1, p=1, q=0
    // 110ns: clock=1, a=1, p=1, q=0
    // 115ns: clock=0, a=0, p=1, q=1
    // 120ns: clock=0, a=1, p=1, q=1
    // This implies:
    // p = a (when clock=1)
    // q = p (when clock=0)
    
    // Let's try continuous assignment as the simulation is very simple.
    // It's possible p is just 'a' when 'clock' is 1.
    // Let's try a latch-like behavior.
    
    always_latch begin
        if (clock) p = a;
    end
    
    always_latch begin
        if (!clock) q = p;
    end
    
endmodule
