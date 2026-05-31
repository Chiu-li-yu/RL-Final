module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    logic [1:0] current_level, prev_level;

    // Correcting the logic interpretation:
    // When the water level is between the upper and lower sensors,
    // (i.e., Level 2 or Level 1), the flow rate is determined by (current_level)
    // AND (prev_level > current_level).
    // The previous level is the level recorded BEFORE the last sensor change.

    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    // Use a state-like approach to track the *previous* level when a change occurs.
    always_ff @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
        end else if (current_level != prev_level) begin
            prev_level <= current_level;
        end
    end

    // The logic needs to compare the level at the *instant before* the current level.
    // Let's store the state and update it only when sensors change.
    // The previous level (before the sensor change) must be captured.

    logic [1:0] stable_level;
    always_ff @(posedge clk) begin
        if (reset) begin
            stable_level <= 2'd0;
            prev_level <= 2'd0;
        end else if (current_level != stable_level) begin
            prev_level <= stable_level;
            stable_level <= current_level;
        end
    end

    always @(*) begin
        if (reset) {fr2, fr1, fr0, dfr} = 4'b1111;
        else begin
            // Base nominal flows
            fr2 = (current_level == 2'd0);
            fr1 = (current_level == 2'd0 || current_level == 2'd1);
            fr0 = (current_level == 2'd0 || current_level == 2'd1 || current_level == 2'd2);
            // Supplemental
            dfr = (current_level == 2'd1 || current_level == 2'd2) && (prev_level > current_level);
        end
    end
endmodule
