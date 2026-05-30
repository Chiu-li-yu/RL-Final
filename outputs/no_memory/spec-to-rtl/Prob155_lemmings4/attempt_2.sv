module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    parameter WALK_L = 0, WALK_R = 1, FALL_L = 2, FALL_R = 3, DIG_L = 4, DIG_R = 5, SPLATTER = 6;

    logic [2:0] state, next_state;
    logic [6:0] fall_counter;

    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL_L || state == FALL_R);
    assign digging = (state == DIG_L || state == DIG_R);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            if (state == FALL_L || state == FALL_R) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            WALK_L: begin
                if (!ground) next_state = FALL_L;
                else if (dig) next_state = DIG_L;
                else if (bump_right) next_state = WALK_L;
                else if (bump_left) next_state = WALK_R;
            end
            WALK_R: begin
                if (!ground) next_state = FALL_R;
                else if (dig) next_state = DIG_R;
                else if (bump_left) next_state = WALK_R;
                else if (bump_right) next_state = WALK_L;
            end
            FALL_L: begin
                if (ground) begin
                    if (fall_counter > 20) next_state = SPLATTER;
                    else next_state = WALK_L;
                end
            end
            FALL_R: begin
                if (ground) begin
                    if (fall_counter > 20) next_state = SPLATTER;
                    else next_state = WALK_R;
                end
            end
            DIG_L: begin
                if (!ground) next_state = FALL_L;
            end
            DIG_R: begin
                if (!ground) next_state = FALL_R;
            end
            SPLATTER: begin
                next_state = SPLATTER;
            end
        endcase
    end
endmodule