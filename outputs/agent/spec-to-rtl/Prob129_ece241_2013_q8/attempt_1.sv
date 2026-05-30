module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);
    logic [1:0] state, next_state;

    parameter S0 = 2'd0; // Reset / No progress
    parameter S1 = 2'd1; // '1' seen
    parameter S2 = 2'd2; // '10' seen

    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S1 : S2;
            S2: next_state = (x) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    assign z = (state == S2 && x == 1'b1);

endmodule
