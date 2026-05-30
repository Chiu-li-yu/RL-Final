module TopModule(
    input clock,
    input a,
    output p,
    output q
);
    // Let's re-analyze the waveforms carefully:
    // 90ns:  clk=1, a=1 -> p=1, q=0
    // 115ns: clk=0, a=0 -> p=1, q=1
    // 145ns: clk=1, a=0 -> p=0, q=1
    // 165ns: clk=1, a=1 -> p=1, q=1
    // 175ns: clk=0, a=1 -> p=0, q=0

    // p = a & clock is not quite right because at 115ns, a=0, clk=0 but p=1.
    // Looking at p:
    // 70ns: a=1, clk=0 -> p=1
    // 80ns: a=1, clk=0 -> p=1
    // 90ns: a=1, clk=1 -> p=1
    // 115ns: a=0, clk=0 -> p=1
    // 165ns: a=1, clk=1 -> p=1
    
    // Maybe p = a | ~clock?
    // 90ns: 1 | 0 = 1 (True)
    // 115ns: 0 | 1 = 1 (True)
    // 145ns: 0 | 0 = 0 (True)
    // 165ns: 1 | 0 = 1 (True)
    // 175ns: 1 | 1 = 1 (False? Waveform says 175ns: p=0)
    
    // Wait, the waveform says:
    // 175ns: clock=0, a=1, p=0, q=0
    // 185ns: clock=0, a=1, p=0, q=0
    // 70ns:  clock=0, a=1, p=1, q=0
    
    // The only difference is the previous states.
    // This is definitely a sequential circuit.
    
    logic p_reg, q_reg;
    
    always @(*) begin
        // Let's try a simple D flip-flop based state machine
    end

    // Let's use two DFFs
    logic q1, q2;
    always_ff @(posedge clock) begin
        q1 <= a;
        q2 <= q1;
    end
    
    assign p = (a ^ q1) & ~clock;
    assign q = q1 & q2;

endmodule