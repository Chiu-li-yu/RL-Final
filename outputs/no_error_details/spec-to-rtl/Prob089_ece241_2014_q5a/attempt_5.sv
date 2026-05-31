module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // To make it a Moore machine, the output must be a function of the state only.
    // Standard approach: 
    // State is defined by:
    // S0: No '1' seen yet (Output 0)
    // S1: Found a '1' (Output 1)
    // S2: After finding '1', output 0
    // S3: After finding '1', output 1
    
    // Actually, simply:
    // State 0: No 1 seen (Output is 0)
    // State 1: 1 seen (Output is 1)
    // No, that's not right. 2's complement is:
    // ...00100 -> ...11100
    // LSB: 0, Output: 0
    // Next: 0, Output: 0
    // Next: 1, Output: 1
    // Next: 0, Output: 1
    // Next: 0, Output: 1
    
    // If output is register:
    // S0: No 1 seen (out 0)
    // S1: Found a 1 (out 1)
    // S2: Found 1, output 0 (out 0)
    // S3: Found 1, output 1 (out 1)
    
    logic [1:0] state;
    
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00;
        else begin
            case (state)
                2'b00: state <= (x) ? 2'b01 : 2'b00;
                2'b01: state <= (x) ? 2'b11 : 2'b10;
                2'b10: state <= (x) ? 2'b11 : 2'b10;
                2'b11: state <= (x) ? 2'b11 : 2'b10;
                default: state <= 2'b00;
            endcase
        end
    end
    
    assign z = (state == 2'b01 || state == 2'b11);

endmodule
