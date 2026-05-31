module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // prev_s stores the sensor state from the previous cycle
    logic [2:0] prev_s;
    logic       prev_level_higher;

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Water level logic
    // s[2], s[1], s[0]
    // 111: Above s[2]
    // 011: Between s[2] and s[1]
    // 001: Between s[1] and s[0]
    // 000: Below s[0]

    always @(*) begin
        // Determine if previous level was higher
        // A "higher" level has more bits set to 1
        // Simplified: prev_s had more bits set than s
        // Or strictly based on the sensors changing:
        // Actually the problem says "If the sensor change indicates that the previous level was higher than the current level"
        // This implies comparing the count of bits set, or state order.
        
        // Define level as an integer 0 (low) to 3 (high)
        // Level 3: s=111, Level 2: s=011, Level 1: s=001, Level 0: s=000
        
        logic [1:0] curr_level, last_level;
        
        case (s)
            3'b111: curr_level = 2'd3;
            3'b011: curr_level = 2'd2;
            3'b001: curr_level = 2'd1;
            default: curr_level = 2'd0;
        endcase
        
        case (prev_s)
            3'b111: last_level = 2'd3;
            3'b011: last_level = 2'd2;
            3'b001: last_level = 2'd1;
            default: last_level = 2'd0;
        endcase

        // If the level has changed, check if it decreased
        if (s != prev_s)
            prev_level_higher = (last_level > curr_level);
        else
            prev_level_higher = 0; // Or keep previous? Specification says "If the sensor change indicates"
            // Let's assume it only triggers on change.

        // Nominal Flow Rate logic
        fr2 = 0; fr1 = 0; fr0 = 0;
        case (s)
            3'b111: begin /* No nominal */ end
            3'b011: begin fr0 = 1; end
            3'b001: begin fr0 = 1; fr1 = 1; end
            3'b000: begin fr0 = 1; fr1 = 1; fr2 = 1; end
            default: begin fr0 = 1; fr1 = 1; fr2 = 1; end
        endcase

        // Supplemental flow valve
        if (reset) dfr = 1;
        else if (s != prev_s && prev_level_higher) dfr = 1;
        else if (s == 3'b000) dfr = 1; // Below s[0]
        else dfr = 0;
    end
endmodule