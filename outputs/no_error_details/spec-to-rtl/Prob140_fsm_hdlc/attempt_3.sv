module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    typedef enum logic [3:0] {
        ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7, ST_DISC, ST_FLAG, ST_ERR
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= ST0;
        else state <= ST0; // wait, needs to be ST0
        // correction
    end

    // Actually, logic is:
    // Reset state: "behaves as though the previous input were 0"
    // So ST0 is the base state.
    
    always_ff @(posedge clk) begin
        if (reset) state <= ST0;
        else state <= next_state;
    end

    always @(*) begin
        case(state)
            ST0: next_state = (in) ? ST1 : ST0;
            ST1: next_state = (in) ? ST2 : ST0;
            ST2: next_state = (in) ? ST3 : ST0;
            ST3: next_state = (in) ? ST4 : ST0;
            ST4: next_state = (in) ? ST5 : ST0;
            ST5: next_state = (in) ? ST6 : ST0;
            ST6: next_state = (in) ? ST7 : ST0;
            ST7: next_state = (in) ? ST7 : ST0;
            default: next_state = ST0;
        endcase
    end

    // Moore outputs:
    // 0111110 (5 ones followed by 0) -> disc
    // 01111110 (6 ones followed by 0) -> flag
    // 01111111... (7+ ones) -> err
    
    // We need to track the sequence length and detect the pattern.
    // Let's use the counter approach.
    
    logic [3:0] count;
    always_ff @(posedge clk) begin
        if (reset) count <= 0;
        else if (in) count <= (count < 8) ? count + 1 : 8;
        else count <= 0;
    end
    
    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= (!in && count == 5);
            flag <= (!in && count == 6);
            err  <= (in && count >= 7);
        end
    end

endmodule
