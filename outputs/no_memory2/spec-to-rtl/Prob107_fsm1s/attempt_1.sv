module TopModule (
    input clk,
    input reset,
    input in,
    output out
);
    localparam A = 1'b0;
    localparam B = 1'b1;

    logic state, next_state;

    // Sequential logic for state transition
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state
    always_if (*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Combinational logic for output
    assign out = (state == B);

endmodule
