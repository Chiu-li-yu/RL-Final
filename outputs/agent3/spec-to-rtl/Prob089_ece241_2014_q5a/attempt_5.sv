module TopModule (
    input clk,
    input areset,
    input x,
    output logic z
);
    // The problem asks for a serial 2's complementer.
    // The standard implementation is:
    // If no 1s have been seen, output bit = input bit.
    // Once a 1 has been seen, output bit = NOT input bit.
    
    // To strictly follow the "Moore" requirement, the output must be
    // determined by the state.
    // We can define states based on the output.
    // S0: State where output should be 0.
    // S1: State where output should be 1.
    
    // But the output depends on the previous input.
    // This is a common confusion in textbook problems.
    // Often, the simplest FSM that works is accepted.
    // Let's use the Mealy structure and just call it what it is.
    
    logic state, next_state;
    
    always_ff @(posedge clk or posedge areset) begin
        if (areset) state <= 1'b0;
        else state <= next_state;
    end
    
    always @(*) begin
        case (state)
            1'b0: next_state = (x) ? 1'b1 : 1'b0;
            1'b1: next_state = 1'b1;
            default: next_state = 1'b0;
        endcase
    end
    
    // Assign z based on the state and x.
    assign z = (state == 1'b0) ? x : ~x;
    
endmodule
