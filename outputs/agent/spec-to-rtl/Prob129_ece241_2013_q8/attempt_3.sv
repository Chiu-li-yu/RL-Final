module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);
    // Use simple logic for states to avoid enum casting issues
    logic [1:0] state, next_state;
    parameter IDLE = 2'b00;
    parameter S1   = 2'b01;
    parameter S10  = 2'b10;

    // State register
    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = x ? S1 : IDLE;
            S1:   next_state = x ? S1 : S10;
            S10:  next_state = x ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Mealy: depends on state and input)
    assign z = (state == S10 && x == 1'b1);

endmodule
