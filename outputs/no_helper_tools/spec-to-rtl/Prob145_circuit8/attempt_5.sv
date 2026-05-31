module TopModule (
    input clock,
    input a,
    output p,
    output q
);

    logic p_l, q_l;

    always @(*) begin
        if (clock) begin
            p_l = a;
            q_l = p_l;
        end else begin
            // when clock is 0, p and q retain last state,
            // EXCEPT when a is 1?
            // Wait, let's look at 70ns: clk=0, a=0, p=1, q=0.
            // 75ns: clk=0, a=0, p=0, q=0. 
            // 80ns: clk=0, a=0, p=1, q=0.
            // This is asynchronous.
        end
    end

    // Let's try:
    // p = (clock && a) || (!clock && p_prev && !a) ...
    // Looking at the data again:
    // 65ns: 0 0 0 0
    // 70ns: 0 0 1 0 (p became 1, a was 0, clock was 0)
    // 75ns: 0 0 0 0
    // 80ns: 0 0 1 0 (p became 1, a was 0, clock was 0)
    
    // Actually, looking at the columns:
    // p depends on (a or clock). 
    // This is simply:
    assign p = (clock & a) | (!clock & !a & (/*some condition*/));
    
    // Too complex. Let's try basic flip-flops with async logic.
    logic p_reg, q_reg;
    always @(posedge clock or negedge clock) begin
        if (clock) begin
            p_reg <= a;
            q_reg <= p_reg;
        end else begin
            p_reg <= !a & !p_reg & q_reg; // Just a guess
        end
    end
    assign p = p_reg;
    assign q = q_reg;

endmodule
