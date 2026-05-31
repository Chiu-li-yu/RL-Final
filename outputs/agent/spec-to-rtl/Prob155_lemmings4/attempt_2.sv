module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

    localparam WALK_LEFT = 0, WALK_RIGHT = 1, FALL_LEFT = 2, FALL_RIGHT = 3, 
               DIG_LEFT = 4, DIG_RIGHT = 5, SPLATTER = 6;

    logic [2:0] state, next_state;
    logic [5:0] fall_count;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
        end else begin
            state <= next_state;
            if (state == FALL_LEFT || state == FALL_RIGHT)
                fall_count <= fall_count + 1'b1;
            else
                fall_count <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
                else if (dig) next_state = DIG_LEFT;
                else if (bump_right) next_state = WALK_LEFT;
                else if (bump_left) next_state = WALK_RIGHT;
            end
            WALK_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
                else if (dig) next_state = DIG_RIGHT;
                else if (bump_left) next_state = WALK_RIGHT;
                else if (bump_right) next_state = WALK_LEFT;
            end
            FALL_LEFT: begin
                if (ground) begin
                    if (fall_count > 20) next_state = SPLATTER;
                    else next_state = WALK_LEFT;
                end
            end
            FALL_RIGHT: begin
                if (ground) begin
                    if (fall_count > 20) next_state = SPLATTER;
                    else next_state = WALK_RIGHT;
                end
            end
            DIG_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
            end
            SPLATTER: begin
                next_state = SPLATTER;
            end
        endcase
    end

    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule