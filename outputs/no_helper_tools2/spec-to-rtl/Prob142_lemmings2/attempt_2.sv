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

    // States: 0 = LEFT, 1 = RIGHT, 2 = FALL_LEFT, 3 = FALL_RIGHT
    logic [1:0] state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // Walk Left
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            2'b00: begin // LEFT
                if (!ground) next_state = 2'b10; // FALL_LEFT
                else if (bump_right) next_state = 2'b01; // RIGHT
                else next_state = 2'b00;
            end
            2'b01: begin // RIGHT
                if (!ground) next_state = 2'b11; // FALL_RIGHT
                else if (bump_left) next_state = 2'b00; // LEFT
                else next_state = 2'b01;
            end
            2'b10: begin // FALL_LEFT
                if (ground) next_state = 2'b00;
                else next_state = 2'b10;
            end
            2'b11: begin // FALL_RIGHT
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
