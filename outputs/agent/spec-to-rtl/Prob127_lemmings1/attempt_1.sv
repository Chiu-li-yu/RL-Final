
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    localparam S_LEFT  = 1'b0;
    localparam S_RIGHT = 1'b1;

    logic state;
    logic next_state;

    // State Transition Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        case (state)
            S_LEFT: begin
                if (bump_left) begin
                    next_state = S_RIGHT;
                end else begin
                    next_state = S_LEFT;
                end
            end
            S_RIGHT: begin
                if (bump_right) begin
                    next_state = S_LEFT;
                end else begin
                    next_state = S_RIGHT;
                end
            end
            default: begin
                next_state = S_LEFT;
            end
        endcase
    end

    // Output Logic (Moore)
    always @(*) begin
        if (state == S_LEFT) begin
            walk_left  = 1'b1;
            walk_right = 1'b0;
        end else begin
            walk_left  = 1'b0;
            walk_right = 1'b1;
        end
    end

endmodule
