module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // Re-reading: "reset... to a state equivalent to if the water level had been low for a long time (no sensors asserted, and all four outputs asserted)."
    // My previous attempts to define prev_level might be overcomplicating.
    // Let's use a standard FSM where the output is determined by current state (which represents the level).

    logic [1:0] state; // 00=below, 01=1, 10=2, 11=above
    logic [1:0] next_state;

    always @(*) begin
        if (s == 3'b111) next_state = 2'd3;
        else if (s == 3'b011) next_state = 2'd2;
        else if (s == 3'b001) next_state = 2'd1;
        else next_state = 2'd0;
    end

    always_ff @(posedge clk) begin
        if (reset)
            state <= 2'd0;
        else
            state <= next_state;
    end

    // dfr is true if the *previous* level was higher than *current* level.
    // In a clocked design, this means prev_state > next_state.
    always @(*) begin
        // Nominal flow
        case (next_state)
            2'd3: {fr2, fr1, fr0} = 3'b000;
            2'd2: {fr2, fr1, fr0} = 3'b001;
            2'd1: {fr2, fr1, fr0} = 3'b011;
            2'd0: {fr2, fr1, fr0} = 3'b111;
            default: {fr2, fr1, fr0} = 3'b000;
        endcase

        // dfr logic
        if (state > next_state)
            dfr = 1'b1;
        else
            dfr = 1'b0;
    end
endmodule
