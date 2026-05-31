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

    // Let's re-examine the table
    // 70ns: a=1, b=1, state=0
    // 75ns: a=0, b=0, state=1, q=1 (rising edge)
    // 85ns: a=1, b=1, state=0, q=0 (rising edge)
    // 95ns: a=1, b=1, state=1, q=1 (rising edge)
    // 115ns: a=1, b=0, state=1, q=0 (rising edge)

    // Wait, the table shows the state *before* the rising edge as well.
    // 65ns: a=1, b=1, state=0 (at clock 0)
    // 75ns: a=0, b=0, state=1, q=1 (at clock 1)
    
    // Maybe: 
    // next_state = (a & b) | (~a & ~b & ~state) | (a & ~b & state) ... this is hard.
    
    // Let's look at it as a simple logic gate circuit:
    // q = a ^ b ^ state? (tried)
    // Maybe q = a ^ b; next_state = b ^ state?
    
    always @(*) begin
        q = a ^ b ^ state;
        next_state = a & b;
    end
endmodule
