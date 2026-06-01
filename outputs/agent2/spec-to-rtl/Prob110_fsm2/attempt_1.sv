module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    logic state, next_state;

    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    assign out = (state == ON);
endmodule