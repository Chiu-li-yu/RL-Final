module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);
    logic [1:0] state, next_state;
    
    // States: 00: IDLE, 01: saw 1, 10: saw 10
    localparam S_IDLE = 2'b00;
    localparam S_1    = 2'b01;
    localparam S_10   = 2'b10;

    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = S_IDLE;
        case (state)
            S_IDLE: next_state = x ? S_1 : S_IDLE;
            S_1:    next_state = x ? S_1 : S_10;
            S_10:   next_state = x ? S_1 : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    assign z = (state == S_10 && x == 1'b1);

endmodule
