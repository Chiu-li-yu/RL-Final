module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // States: 
    // 0: Walk Left
    // 1: Walk Right
    // 2: Fall Left
    // 3: Fall Right
    logic [1:0] state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            2'b00: begin // Left
                if (!ground) next_state = 2'b10;
                else if (bump_left && bump_right) next_state = 2'b01;
                else if (bump_right) next_state = 2'b01;
                else next_state = 2'b00;
            end
            2'b01: begin // Right
                if (!ground) next_state = 2'b11;
                else if (bump_left && bump_right) next_state = 2'b00;
                else if (bump_left) next_state = 2'b00;
                else next_state = 2'b01;
            end
            2'b10: begin // Fall Left
                if (ground) next_state = 2'b00;
                else next_state = 2'b10;
            end
            2'b11: begin // Fall Right
                if (ground) next_state = 2'b01;
                else next_state = 2'b11;
            end
            default: next_state = 2'b00;
        endcase
    end

    assign walk_left  = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    assign aaah       = (state == 2'b10 || state == 2'b11);

endmodule
