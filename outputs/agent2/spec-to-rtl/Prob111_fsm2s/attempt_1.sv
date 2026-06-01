module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    logic state;
    logic next_state;

    localparam OFF = 1'b0;
    localparam ON = 1'b1;

    always_ff @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    assign out = (state == ON);

endmodule
