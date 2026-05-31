module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // Current and Previous State representing the water level (3'b111, 3'b011, 3'b001, 3'b000)
    // Actually, based on the problem, sensors are at intervals.
    // The sensors indicate:
    // 3'b111: Above s[2] (Level 3)
    // 3'b011: Between s[2] and s[1] (Level 2)
    // 3'b001: Between s[1] and s[0] (Level 1)
    // 3'b000: Below s[0] (Level 0)

    logic [1:0] current_level;
    logic [1:0] prev_level;

    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    always_ff @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0;
        else
            prev_level <= current_level;
    end

    always @(*) begin
        // Nominal Flow Rate based on current level
        case (current_level)
            2'd3: {fr2, fr1, fr0} = 3'b000;
            2'd2: {fr2, fr1, fr0} = 3'b001;
            2'd1: {fr2, fr1, fr0} = 3'b011;
            2'd0: {fr2, fr1, fr0} = 3'b111;
            default: {fr2, fr1, fr0} = 3'b000;
        endcase

        // Supplemental flow (dfr)
        // If the previous level was higher than the current level
        if (prev_level > current_level)
            dfr = 1'b1;
        else
            dfr = 1'b0;
    end
endmodule
