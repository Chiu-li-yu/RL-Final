module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    // States: 
    // S0: 0 consecutive 1s (start/after 0)
    // S1, S2, S3, S4, S5: 1 to 5 consecutive 1s
    // S6: 6 consecutive 1s
    // S7: 7+ consecutive 1s
    // D: 0111110 -> discard
    // F: 01111110 -> flag
    // E: 01111111 -> error
    
    typedef enum logic [3:0] {
        ST_RESET, ST_1, ST_2, ST_3, ST_4, ST_5, ST_6, ST_ERR, ST_DISC, ST_FLAG
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= ST_RESET;
        else state <= next_state;
    end

    always @(*) begin
        case(state)
            ST_RESET: next_state = (in) ? ST_1 : ST_RESET;
            ST_1:     next_state = (in) ? ST_2 : ST_RESET;
            ST_2:     next_state = (in) ? ST_3 : ST_RESET;
            ST_3:     next_state = (in) ? ST_4 : ST_RESET;
            ST_4:     next_state = (in) ? ST_5 : ST_RESET;
            ST_5:     next_state = (in) ? ST_6 : ST_DISC; // 5 1s, next bit 0 -> disc
            ST_6:     next_state = (in) ? ST_ERR : ST_FLAG; // 6 1s, next bit 0 -> flag
            ST_ERR:   next_state = (in) ? ST_ERR : ST_RESET; // 7+ 1s
            ST_DISC:  next_state = (in) ? ST_1 : ST_RESET;
            ST_FLAG:  next_state = (in) ? ST_1 : ST_RESET;
            default:  next_state = ST_RESET;
        endcase
    end

    // Moore outputs: state is the indicator
    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err  <= 0;
        end else begin
            disc <= (next_state == ST_DISC);
            flag <= (next_state == ST_FLAG);
            err  <= (next_state == ST_ERR);
        end
    end

endmodule
