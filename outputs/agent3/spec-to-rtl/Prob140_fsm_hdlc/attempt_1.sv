module TopModule (
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        IDLE = 4'd0,
        S1   = 4'd1,
        S2   = 4'd2,
        S3   = 4'd3,
        S4   = 4'd4,
        S5   = 4'd5,
        S6   = 4'd6,
        DISC_STATE = 4'd7,
        FLAG_STATE = 4'd8,
        ERR_STATE  = 4'd9
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: next_state = in ? S1 : IDLE;
            S1:   next_state = in ? S2 : IDLE;
            S2:   next_state = in ? S3 : IDLE;
            S3:   next_state = in ? S4 : IDLE;
            S4:   next_state = in ? S5 : IDLE;
            S5:   next_state = in ? DISC_STATE : S6; // 0111110 -> disc, else 1
            S6:   next_state = in ? ERR_STATE : FLAG_STATE; // 01111111 -> err, 01111110 -> flag
            DISC_STATE: next_state = in ? S1 : IDLE;
            FLAG_STATE: next_state = in ? S1 : IDLE;
            ERR_STATE:  next_state = in ? ERR_STATE : IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(*) begin
        disc = (current_state == DISC_STATE);
        flag = (current_state == FLAG_STATE);
        err  = (current_state == ERR_STATE);
    end

endmodule
