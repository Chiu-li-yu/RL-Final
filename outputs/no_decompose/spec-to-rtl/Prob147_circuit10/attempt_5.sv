module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

    logic state_reg;
    assign state = state_reg;
    
    // Observed behavior from waveform: 
    // q = a ^ b ^ state_reg (roughly)
    // state is a memory bit
    
    always @(posedge clk) begin
        state_reg <= (a & b) | (state_reg & (a | b));
    end
    
    assign q = (a ^ b) ^ state_reg;

endmodule
