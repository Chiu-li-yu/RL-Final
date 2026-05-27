module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);
    // State definitions
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S1   = 2'b01,
        S10  = 2'b10
    } state_t;

    state_t state, next_state;
    logic z_out;

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
    always @(*) begin
        if (state == S10 && x == 1'b1) begin
            z_out = 1'b1;
        end else begin
            z_out = 1'b0;
        end
    end

    assign z = z_out;

endmodule
