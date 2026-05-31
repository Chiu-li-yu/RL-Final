module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // States
    // 0: A
    // 1: f=1
    // 2: monitor x
    // 3: x=1
    // 4: x=1,0
    // 5: g=1, monitor y (first cycle)
    // 6: g=1, monitor y (second cycle)
    // 7: g=1 perm
    // 8: g=0 perm

    logic [3:0] state, next_state;
    logic g_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= 0;
            g_reg <= 0;
        end else begin
            state <= next_state;
            if (next_state == 5) g_reg <= 1;
            else if (state == 6 && y == 0) g_reg <= 0;
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
            5: next_state = (y == 1) ? 7 : 6;
            6: next_state = (y == 1) ? 7 : 8;
            7: next_state = 7;
            8: next_state = 8;
            default: next_state = 0;
        endcase
    end
endmodule
