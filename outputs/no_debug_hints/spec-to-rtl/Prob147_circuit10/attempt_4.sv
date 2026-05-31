module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    // Re-check transitions:
    // (a=0, b=0, s=0) -> q=0, next_s=0
    // (a=0, b=1, s=0) -> q=1, next_s=0
    // (a=1, b=1, s=0) -> q=0, next_s=1  (time 65->75)
    // (a=0, b=0, s=1) -> q=1, next_s=1
    // (a=1, b=1, s=1) -> q=1, next_s=1
    // (a=1, b=0, s=1) -> q=0, next_s=0  (time 115->125)
    // (a=0, b=1, s=1) -> q=0, next_s=1  (wait, check waveform)
    // Waveform check 125-135: a=0, b=1, s=1 -> q=0. Next is s=1 (at 135)
    
    // Summary:
    // q = a ^ b ^ state
    // next_state:
    // a=1, b=1, s=0 -> 1
    // a=1, b=0, s=1 -> 0
    // a=0, b=0, s=1 -> 1
    // a=0, b=1, s=1 -> 1
    // a=1, b=1, s=1 -> 1
    
    // next_state = (a & b) | (state & ~(a & ~b))
    
    logic next_state;

    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        next_state = (a & b) | (state & ~(a & ~b));
        q = a ^ b ^ state;
    end

endmodule
