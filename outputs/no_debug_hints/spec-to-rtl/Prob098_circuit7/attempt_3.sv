module TopModule (
    input clk,
    input a,
    output logic q
);
    // Let's re-examine the data:
    // 15ns (a=0): q=1
    // 25ns (a=0): q=1
    // 35ns (a=1): q=1
    // 45ns (a=1): q=0
    // 55ns (a=1): q=0
    
    // Maybe q = !(delayed_a1 && delayed_a2)?
    // Or maybe just a simple state machine:
    // State 0: q=1. If a=1 -> goto State 1. Else stay State 0.
    // State 1: q=1. If a=1 -> goto State 2. Else goto State 0.
    // State 2: q=0. If a=1 -> stay State 2. Else goto State 0.
    
    logic [1:0] state;
    
    always_ff @(posedge clk) begin
        case(state)
            2'b00: state <= (a) ? 2'b01 : 2'b00;
            2'b01: state <= (a) ? 2'b10 : 2'b00;
            2'b10: state <= (a) ? 2'b10 : 2'b00;
            default: state <= 2'b00;
        endcase
    end
    
    always_comb begin
        q = (state != 2'b10);
    end

endmodule
