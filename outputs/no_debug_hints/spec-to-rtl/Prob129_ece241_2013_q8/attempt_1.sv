module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // States: 
    // S0: Initial / Waiting for '1'
    // S1: Found '1'
    // S2: Found '10'
    logic [1:0] state, next_state;

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;

    // State Register
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output Logic (Mealy)
    // z is 1 when input x=1 and current state is S2 (sequence "101")
    assign z = (state == S2 && x == 1'b1);

endmodule
