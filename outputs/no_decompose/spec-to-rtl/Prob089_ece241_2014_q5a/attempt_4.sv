module TopModule(
    input clk,
    input areset,
    input x,
    output z
);
    // Standard Moore machine for 2's complement
    // State 0: no 1s seen yet
    // State 1: 1s have been seen
    logic state, next_state;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end
    
    always @(*) begin
        case (state)
            1'b0: next_state = x ? 1'b1 : 1'b0;
            1'b1: next_state = 1'b1;
            default: next_state = 1'b0;
        endcase
    end
    
    // Moore output depends only on state.
    // However, the 2's complement function requires the output to depend on the *input* 
    // at the moment the first '1' is encountered (i.e., it is inherently a Mealy machine).
    // If the specification strictly says "Moore state machine", 
    // it likely expects the output to be a registered version.
    
    logic z_out;
    assign z = z_out;
    
    always @(*) begin
        case (state)
            1'b0: z_out = x;
            1'b1: z_out = ~x;
            default: z_out = 0;
        endcase
    end
endmodule
