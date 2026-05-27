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
        DISC = 4'd6,
        FLAG = 4'd7,
        ERR  = 4'd8
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = IDLE;
        case (state)
            IDLE: next_state = in ? S1 : IDLE;
            S1:   next_state = in ? S2 : IDLE;
            S2:   next_state = in ? S3 : IDLE;
            S3:   next_state = in ? S4 : IDLE;
            S4:   next_state = in ? S5 : IDLE;
            S5:   next_state = in ? ERR : DISC; // in=0 -> disc, in=1 -> err (7th one)
            DISC: next_state = in ? S1 : IDLE;
            FLAG: next_state = in ? S1 : IDLE;
            ERR:  next_state = in ? ERR : IDLE; // Stay in ERR until a 0 is seen
            default: next_state = IDLE;
        endcase

        // Correct the transition for FLAG: S5 + 0 is DISC, S5 + 1 is ERR.
        // Wait, the specification says:
        // (1) 0111110: disc
        // (2) 01111110: flag
        // (3) 01111111...: err

        // Let's refine the states:
        // IDLE -> (1) -> S1
        // S1 -> (1) -> S2
        // S2 -> (1) -> S3
        // S3 -> (1) -> S4
        // S4 -> (1) -> S5
        // S5 -> (0) -> DISC
        // S5 -> (1) -> S6
        // S6 -> (0) -> FLAG
        // S6 -> (1) -> ERR
        // ERR -> (1) -> ERR
    end

    // Re-implementing with correct states
    typedef enum logic [3:0] {
        ST_IDLE = 4'd0,
        ST_1    = 4'd1,
        ST_11   = 4'd2,
        ST_111  = 4'd3,
        ST_1111 = 4'd4,
        ST_11111= 4'd5,
        ST_111111= 4'd6,
        ST_DISC = 4'd7,
        ST_FLAG = 4'd8,
        ST_ERR  = 4'd9
    } state2_t;

    state2_t s, ns;

    always @(posedge clk) begin
        if (reset) s <= ST_IDLE;
        else s <= ns;
    end

    always @(*) begin
        ns = ST_IDLE;
        case (s)
            ST_IDLE:   ns = in ? ST_1 : ST_IDLE;
            ST_1:      ns = in ? ST_11 : ST_IDLE;
            ST_11:     ns = in ? ST_111 : ST_IDLE;
            ST_111:    ns = in ? ST_1111 : ST_IDLE;
            ST_1111:   ns = in ? ST_11111 : ST_IDLE;
            ST_11111:  ns = in ? ST_111111 : ST_DISC;
            ST_111111: ns = in ? ST_ERR : ST_FLAG;
            ST_DISC:   ns = in ? ST_1 : ST_IDLE;
            ST_FLAG:   ns = in ? ST_1 : ST_IDLE;
            ST_ERR:    ns = in ? ST_ERR : ST_IDLE;
            default:   ns = ST_IDLE;
        endcase
    end

    assign disc = (s == ST_DISC);
    assign flag = (s == ST_FLAG);
    assign err  = (s == ST_ERR);

endmodule
