
module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic bump_left,
    input  logic bump_right,
    input  logic ground,
    input  logic dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

    localparam S_WALK_L = 3'd0,
               S_WALK_R = 3'd1,
               S_FALL_L = 3'd2,
               S_FALL_R = 3'd3,
               S_DIG_L  = 3'd4,
               S_DIG_R  = 3'd5,
               S_SPLAT  = 3'd6;

    logic [2:0] state, next_state;
    logic [7:0] fall_counter;

    // State transition logic
    always @(*) begin
        next_state = state;
        case (state)
            S_WALK_L: begin
                if (!ground) 
                    next_state = S_FALL_L;
                else if (dig) 
                    next_state = S_DIG_L;
                else if (bump_left) 
                    next_state = S_WALK_R;
                else 
                    next_state = S_WALK_L;
            end
            S_WALK_R: begin
                if (!ground) 
                    next_state = S_FALL_R;
                else if (dig) 
                    next_state = S_DIG_R;
                else if (bump_right) 
                    next_state = S_WALK_L;
                else 
                    next_state = S_WALK_R;
            end
            S_FALL_L: begin
                if (ground) begin
                    if (fall_counter > 8'd20) 
                        next_state = S_SPLAT;
                    else 
                        next_state = S_WALK_L;
                end else begin
                    next_state = S_FALL_L;
                end
            end
            S_FALL_R: begin
                if (ground) begin
                    if (fall_counter > 8'd20) 
                        next_state = S_SPLAT;
                    else 
                        next_state = S_WALK_R;
                end else begin
                    next_state = S_FALL_R;
                end
            end
            S_DIG_L: begin
                if (!ground) 
                    next_state = S_FALL_L;
                else 
                    next_state = S_DIG_L;
            end
            S_DIG_R: begin
                if (!ground) 
                    next_state = S_FALL_R;
                else 
                    next_state = S_DIG_R;
            end
            S_SPLAT: begin
                next_state = S_SPLAT;
            end
            default: next_state = S_WALK_L;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WALK_L;
            fall_counter <= 8'd0;
        end else begin
            state <= next_state;
            if (next_state == S_FALL_L || next_state == S_FALL_R) begin
                if (state == S_FALL_L || state == S_FALL_R)
                    fall_counter <= fall_counter + 8'd1;
                else
                    fall_counter <= 8'd0;
            end else begin
                fall_counter <= 8'd0;
            end
        end
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left  = (state == S_WALK_L);
        walk_right = (state == S_WALK_R);
        aaah       = (state == S_FALL_L || state == S_FALL_R);
        digging    = (state == S_DIG_L || state == S_DIG_R);
    end

endmodule
