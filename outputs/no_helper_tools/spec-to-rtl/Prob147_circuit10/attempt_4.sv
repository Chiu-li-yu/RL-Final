module TopModule(
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    logic next_state;
    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        // Let's try to infer from the transition at 75ns:
        // clk rising at 75ns. a=0, b=0. state was 0.
        // After 75ns, q=1, state=1.
        // 85ns: a=1, b=1, state was 1. After 85ns, q=0, state=0.
        // 95ns: a=1, b=1, state was 0. After 95ns, q=1, state=1.
        // 115ns: a=1, b=0, state was 1. After 115ns, q=0, state=1.
        
        // This looks like a D flip-flop where D = (a ~^ b) ^ state.
        // q is the output.
        // Let's look at q again.
        // 75ns: q=1. a=0, b=0, state_old=0.
        // 85ns: q=0. a=1, b=1, state_old=1.
        // 95ns: q=1. a=1, b=1, state_old=0.
        // 115ns: q=0. a=1, b=0, state_old=1.
        
        // Maybe q is logic, state is the FF output.
        // q = ~(a ^ b) ^ state
        // next_state = ...
        
        // Let's try:
        next_state = (a ^ b) ^ state;
        q = ~(a ^ b) ^ state;
    end
endmodule
