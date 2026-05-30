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

    localparam WALK_LEFT = 3'd0, WALK_RIGHT = 3'd1, FALL_LEFT = 3'd2, FALL_RIGHT = 3'd3, 
               DIG_LEFT = 3'd4, DIG_RIGHT = 3'd5, SPLATTER = 3'd6;

    logic [2:0] state, next_state;
    logic [7:0] fall_count;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
        end else begin
            state <= next_state;
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                if (!ground) fall_count <= fall_count + 1;
                else fall_count <= 0;
            end else begin
                fall_count <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
                else if (dig) next_state = DIG_LEFT;
                else if (bump_left || bump_right) next_state = WALK_RIGHT;
            end
            WALK_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
                else if (dig) next_state = DIG_RIGHT;
                else if (bump_left || bump_right) next_state = WALK_LEFT;
            end
            DIG_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
            end
            FALL_LEFT: begin
                if (ground) next_state = (fall_count > 20) ? SPLATTER : WALK_LEFT;
            end
            FALL_RIGHT: begin
                if (ground) next_state = (fall_count > 20) ? SPLATTER : WALK_RIGHT;
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
