module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);
    localparam S0 = 2'b00,
               S1 = 2'b01,
               S2 = 2'b10;

    logic [1:0] current_state, next_state;

    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (x) ? S1 : S2;
            S2: next_state = (x) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    assign z = (current_state == S2 && x == 1'b1);

endmodule