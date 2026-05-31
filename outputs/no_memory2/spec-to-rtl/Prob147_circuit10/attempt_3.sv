module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    logic state_reg;
    logic next_state;
    logic q_val;

    always @(posedge clk) begin
        state_reg <= next_state;
    end

    always @(*) begin
        // Truth table analysis:
        // state, a, b | next_state, q
        // 0, 0, 0 | 0, 0
        // 0, 0, 1 | 0, 1
        // 0, 1, 0 | 0, 1
        // 0, 1, 1 | 1, 0
        // 1, 0, 0 | 1, 1
        // 1, 0, 1 | 1, 0
        // 1, 1, 0 | 1, 0
        // 1, 1, 1 | 1, 1
        
        // Simplified Logic:
        // q = (a ^ b) if state==0, else (~(a ^ b)) if state==1? 
        // Wait, let's re-evaluate:
        // state=0: q = a ^ b ? No.
        // state=0: q = (~a & b) | (a & ~b) is XOR. 
        // At 45ns: s=0, a=0, b=1 -> q=1. XOR(0,1)=1. Correct.
        // At 65ns: s=0, a=1, b=1 -> q=0. XOR(1,1)=0. Correct.
        // At 15ns: s=0, a=0, b=0 -> q=0. XOR(0,0)=0. Correct.
        // So when s=0, q = a ^ b.
        
        // state=1: 
        // 75ns: s=0 -> s=1. 
        // 85ns: s=1, a=1, b=1 -> q=0.
        // 115ns: s=1, a=1, b=0 -> q=0.
        // 125ns: s=1, a=0, b=1 -> q=0.
        // 135ns: s=1, a=0, b=0 -> q=1.
        // So when s=1, q = ~(a ^ b) = ~(a ^ b) = (a == b).
        
        q_val = (state_reg == 0) ? (a ^ b) : ~(a ^ b);
        
        // Next State:
        // 0,0,0 -> 0
        // 0,0,1 -> 0
        // 0,1,0 -> 0
        // 0,1,1 -> 1
        // 1,0,0 -> 1
        // 1,0,1 -> 1
        // 1,1,0 -> 1
        // 1,1,1 -> 1
        // next_state = (state & (a | b)) | (~state & a & b) = (state & a) | (state & b) | (a & b)
        next_state = (state_reg & a) | (state_reg & b) | (a & b);
    end

    assign q = q_val;
    assign state = state_reg;

endmodule
