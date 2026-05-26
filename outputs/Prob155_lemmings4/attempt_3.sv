module TopModule (
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

    parameter WL = 0, WR = 1, FL = 2, FR = 3, DL = 4, DR = 5, SPLAT = 6;

    logic [2:0] state, next_state;
    logic [4:0] count;
    logic [4:0] next_count;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            count <= 0;
        end else begin
            state <= next_state;
            count <= next_count;
        end
    end

    always @(*) begin
        next_state = state;
        next_count = 0;

        case (state)
            WL: begin
                if (!ground) next_state = FL;
                else if (dig) next_state = DL;
                else if (bump_left) next_state = WR;
                else if (bump_right) next_state = WL;
            end
            WR: begin
                if (!ground) next_state = FR;
                else if (dig) next_state = DR;
                else if (bump_right) next_state = WL;
                else if (bump_left) next_state = WR;
            end
            FL: begin
                if (!ground) begin
                    next_count = count + 1;
                    next_state = FL;
                end else begin
                    if (count > 20) next_state = SPLAT;
                    else next_state = WL;
                end
            end
            FR: begin
                if (!ground) begin
                    next_count = count + 1;
                    next_state = FR;
                end else begin
                    if (count > 20) next_state = SPLAT;
                    else next_state = WR;
                end
            end
            DL: begin
                if (!ground) next_state = FL;
            end
            DR: begin
                if (!ground) next_state = FR;
            end
            SPLAT: next_state = SPLAT;
        endcase
    end

    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule