module TopModule (
    input clk,
    input aresetn,
    input x,
    output logic z
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S1   = 2'b01,
        S10  = 2'b10
    } state_t;

    state_t state, next_state;

    // State transition logic (Sequential)
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (Combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = (x) ? S1 : IDLE;
            S1:   next_state = (x) ? S1 : S10;
            S10:  next_state = (x) ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Mealy: dependent on input x)
    always @(*) begin
        if (state == S10 && x == 1'b1)
            z = 1'b1;
        else
            z = 1'b0;
    end

endmodule
