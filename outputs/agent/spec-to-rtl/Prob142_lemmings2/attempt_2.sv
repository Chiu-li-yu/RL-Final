
module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output logic walk_left,
    output logic walk_right,
    output logic aaah
);

    localparam WALK_LEFT = 2'd0,
               WALK_RIGHT = 2'd1,
               FALLING_LEFT = 2'd2,
               FALLING_RIGHT = 2'd3;

    logic [1:0] state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING_LEFT;
                end else if (bump_left == 1'b1) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    next_state = FALLING_RIGHT;
                end else if (bump_right == 1'b1) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING_LEFT: begin
                if (ground == 1'b1) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = FALLING_LEFT;
                end
            end
            FALLING_RIGHT: begin
                if (ground == 1'b1) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING_RIGHT;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        case (state)
            WALK_LEFT: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
            WALK_RIGHT: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
            end
            FALLING_LEFT: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
            FALLING_RIGHT: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
            default: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
            end
        endcase
    end

endmodule
