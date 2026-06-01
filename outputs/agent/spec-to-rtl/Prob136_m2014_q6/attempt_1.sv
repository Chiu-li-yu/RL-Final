module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // States: A=0, B=1, C=2, D=3, E=4, F=5
    logic [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= 3'd0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            3'd0: next_state = (w) ? 3'd0 : 3'd1; // A
            3'd1: next_state = (w) ? 3'd3 : 3'd2; // B
            3'd2: next_state = (w) ? 3'd3 : 3'd4; // C
            3'd3: next_state = (w) ? 3'd0 : 3'd5; // D
            3'd4: next_state = (w) ? 3'd3 : 3'd4; // E
            3'd5: next_state = (w) ? 3'd3 : 3'd2; // F
            default: next_state = 3'd0;
        endcase
    end

    // Output logic: A(0), B(0), C(0), D(0), E(1), F(1)
    assign z = (state == 3'd4 || state == 3'd5);

endmodule
