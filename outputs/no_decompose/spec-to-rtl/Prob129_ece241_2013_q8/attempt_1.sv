module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);
    // Sequence "101" detector, 3 states, Mealy.
    // States:
    // S0: Idle / Reset
    // S1: Received '1'
    // S2: Received '10'
    
    logic [1:0] state, next_state;
    logic z_out;

    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= 2'b00;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            2'b00: next_state = x ? 2'b01 : 2'b00;
            2'b01: next_state = x ? 2'b01 : 2'b10;
            2'b10: next_state = x ? 2'b01 : 2'b00;
            default: next_state = 2'b00;
        endcase
    end

    always_comb begin
        if (state == 2'b10 && x == 1'b1)
            z_out = 1'b1;
        else
            z_out = 1'b0;
    end

    assign z = z_out;

endmodule
