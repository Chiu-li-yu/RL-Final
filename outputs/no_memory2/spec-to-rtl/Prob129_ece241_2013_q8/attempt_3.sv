module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);
    // 3 states: 
    // IDLE: haven't seen '1'
    // S1: saw '1'
    // S10: saw '10'
    parameter IDLE = 2'b00,
              S1   = 2'b01,
              S10  = 2'b10;

    logic [1:0] state, next_state;

    // Sequential logic: State update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Combinational logic: State transitions and output
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: next_state = x ? S1 : IDLE;
            S1:   next_state = x ? S1 : S10;
            S10:  next_state = x ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Mealy output: z = 1 if current state is S10 and input x is 1
    assign z = (state == S10 && x == 1'b1);

endmodule