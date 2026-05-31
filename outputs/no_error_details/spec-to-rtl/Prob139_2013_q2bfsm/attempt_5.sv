module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);
    // States:
    // A: 0
    // F: 1
    // Monitor X: 2
    // S1: 3 (saw 1)
    // S10: 4 (saw 1,0)
    // G_Wait: 5 (next cycle set g=1)
    // G1_1: 6 (g=1, cycle 1 of y)
    // G1_2: 7 (g=1, cycle 2 of y)
    // G_Perm: 8 (g=1)
    // G_Zero: 9 (g=0)

    logic [3:0] state, next_state;
    logic g_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= 0;
            g_reg <= 0;
        end else begin
            state <= next_state;
            if (next_state == 6) g_reg <= 1;
            else if (state == 7 && y == 0) g_reg <= 0;
        end
    end

    assign f = (state == 1);
    assign g = g_reg;

    always @(*) begin
        case (state)
            0: next_state = 1;
            1: next_state = (x == 1) ? 3 : 2;
            2: next_state = (x == 1) ? 3 : 2;
            3: next_state = (x == 0) ? 4 : 3;
            4: next_state = (x == 1) ? 5 : 2;
            5: next_state = 6;
            6: next_state = (y == 1) ? 8 : 7;
            7: next_state = (y == 1) ? 8 : 9;
            8: next_state = 8;
            9: next_state = 9;
            default: next_state = 0;
        endcase
    end
endmodule
