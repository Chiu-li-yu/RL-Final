module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    // 2's complement: keep bits until first '1', then invert.
    // LSB first.
    // Ex: 12 (01100) -> -12 (10100)
    // 1st: 0, z=0 (S0)
    // 2nd: 0, z=0 (S0)
    // 3rd: 1, z=1 (S0 -> S1)
    // 4th: 1, z=0 (S1)
    // 5th: 0, z=1 (S1)
    
    logic state; // 0: S0 (no 1 yet), 1: S1 (seen 1)

    // Combinational logic for next state (Moore machine)
    // State logic:
    // If state S0 and x=1, next state is S1.
    // If state S1, next state is S1.
    
    // BUT the output z depends on current state AND input if we look closely at 2's complement logic
    // Moore Machine: Output depends only on current state.
    // Wait, the standard 2's comp serial machine IS a Mealy machine typically, 
    // but if it MUST be Moore, I need more states or a delay.
    // Let's re-read: "serial 2's complementer Moore state machine"
    
    // To make it Moore:
    // S0: output 0, no 1 seen
    // S1: output 1, 1 seen
    // S2: output 0, 1 seen
    
    // Actually, simple logic:
    // S0: no 1 yet, z = x (if x=0, z=0)
    // S1: 1 seen, z = ~x
    // If x=1 in S0, z=1, goto S1.
    
    // Let's try 3 states for Moore:
    // S0 (start, output 0)
    // S1 (output 1)
    // S2 (output 0)
    
    typedef enum logic [1:0] { S0, S1, S2 } state_t;
    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) state <= S0;
        else state <= next_state;
    end

    always @(*) begin
        case (state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S2 : S1;
            S2: next_state = (x) ? S2 : S1;
            default: next_state = S0;
        endcase
    end

    always @(*) begin
        case (state)
            S0: z = 0;
            S1: z = 1;
            S2: z = 0;
            default: z = 0;
        endcase
    end
endmodule
