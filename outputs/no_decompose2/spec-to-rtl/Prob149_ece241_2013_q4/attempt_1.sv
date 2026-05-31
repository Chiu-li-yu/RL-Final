module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding based on sensor levels:
    // S3: Above s[2] (s=3'b111)
    // S2: Between s[2] and s[1] (s=3'b011)
    // S1: Between s[1] and s[0] (s=3'b001)
    // S0: Below s[0] (s=3'b000)

    logic [1:0] current_state, next_state;
    logic prev_level_higher; // 1 if previous level was higher, 0 if lower or same
    logic [1:0] prev_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= 2'b00; // S0
            prev_state <= 2'b00;    // Reset state: low for a long time
        end else begin
            current_state <= next_state;
            prev_state <= current_state;
        end
    end

    always @(*) begin
        // Determine current level from sensors
        case (s)
            3'b111: next_state = 2'b11; // S3
            3'b011: next_state = 2'b10; // S2
            3'b001: next_state = 2'b01; // S1
            3'b000: next_state = 2'b00; // S0
            default: next_state = current_state; // Stay in current state if sensor invalid
        endcase

        // If current state index < prev_state index, then prev level was higher
        prev_level_higher = (prev_state > next_state);

        // Outputs
        // Above s[2] (S3): 0, 0, 0, 0
        // Between s[2]/s[1] (S2): fr0=1, fr1=0, fr2=0, dfr=prev_level_higher
        // Between s[1]/s[0] (S1): fr0=1, fr1=1, fr2=0, dfr=prev_level_higher
        // Below s[0] (S0): fr0=1, fr1=1, fr2=1, dfr=0 (or 1 depending on interpretation)
        // Spec: "Below s[0] (None asserted)": fr0, fr1, fr2 asserted.
        // Spec: "If sensor change indicates prev level was higher, dfr opened."

        if (next_state == 2'b11) begin
            {fr2, fr1, fr0, dfr} = 4'b0000;
        end else if (next_state == 2'b10) begin
            {fr2, fr1, fr0, dfr} = {1'b0, 1'b0, 1'b1, prev_level_higher};
        end else if (next_state == 2'b01) begin
            {fr2, fr1, fr0, dfr} = {1'b0, 1'b1, 1'b1, prev_level_higher};
        end else begin // S0
            {fr2, fr1, fr0, dfr} = {1'b1, 1'b1, 1'b1, 1'b0};
        end
    end

endmodule
