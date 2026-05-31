module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;

    logic state, next_state;

    // Output logic (Moore machine: output depends only on state)
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

    // Next state logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (bump_left)
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end
            RIGHT: begin
                if (bump_right)
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end
            default: next_state = LEFT;
        endcase
        
        // Handling both bumps: switch direction
        if (bump_left && bump_right)
            next_state = ~state;
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end

endmodule