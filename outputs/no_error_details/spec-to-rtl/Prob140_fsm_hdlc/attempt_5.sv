module TopModule(
    input clk,
    input reset,
    input in,
    output logic disc,
    output logic flag,
    output logic err
);

    // States representing current count of consecutive 1s
    typedef enum logic [3:0] {
        ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= ST0;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case(state)
            ST0: next_state = (in) ? ST1 : ST0;
            ST1: next_state = (in) ? ST2 : ST0;
            ST2: next_state = (in) ? ST3 : ST0;
            ST3: next_state = (in) ? ST4 : ST0;
            ST4: next_state = (in) ? ST5 : ST0;
            ST5: next_state = (in) ? ST6 : ST0;
            ST6: next_state = (in) ? ST7 : ST0;
            ST7: next_state = (in) ? ST7 : ST0;
        endcase
    end

    // Moore outputs:
    // Asserted for a full cycle AFTER the condition occurs.
    always_ff @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= (!in && state == ST5);
            flag <= (!in && state == ST6);
            err  <= (in && state == ST7);
        end
    end

endmodule
