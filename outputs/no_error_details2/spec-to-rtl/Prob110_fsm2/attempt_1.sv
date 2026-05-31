module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    logic state, next_state;
    
    // States: 0 = OFF, 1 = ON
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    assign out = (state == ON);

endmodule
