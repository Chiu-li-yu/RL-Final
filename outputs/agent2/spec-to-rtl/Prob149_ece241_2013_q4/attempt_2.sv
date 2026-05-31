module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);
    // Level definition based on table:
    // "Above s[2]": s[0], s[1], s[2] asserted. (Input s=3'b111)
    // "Between s[2] and s[1]": s[0], s[1] asserted. (Input s=3'b011)
    // "Between s[1] and s[0]": s[0] asserted. (Input s=3'b001)
    // "Below s[0]": None asserted. (Input s=3'b000)

    logic [1:0] current_level;
    logic [1:0] prev_level;

    always @(*) begin
        case (s)
            3'b111: current_level = 2'd3; // Above s2
            3'b011: current_level = 2'd2; // s2..s1
            3'b001: current_level = 2'd1; // s1..s0
            default: current_level = 2'd0; // Below s0
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0; // Reset state: below s0
        else
            prev_level <= current_level;
    end

    always @(*) begin
        // Nominal Flow Rate Outputs
        // Level 3: None
        // Level 2: fr0
        // Level 1: fr0, fr1
        // Level 0: fr0, fr1, fr2
        case (current_level)
            2'd3: {fr2, fr1, fr0} = 3'b000;
            2'd2: {fr2, fr1, fr0} = 3'b001;
            2'd1: {fr2, fr1, fr0} = 3'b011;
            2'd0: {fr2, fr1, fr0} = 3'b111;
            default: {fr2, fr1, fr0} = 3'b000;
        endcase

        // Supplemental flow (dfr) logic:
        // "If the sensor change indicates that the previous level was higher than 
        //  the current level, the flow rate should be increased by opening 
        //  the Supplemental flow valve (controlled by dfr)."
        // Also, "When the level is below the lowest sensor s[0], the flow rate 
        //  should be at maximum (both Nominal flow valve and Supplemental flow valve opened)."
        
        if (current_level == 2'd0)
            dfr = 1'b1;
        else if (prev_level > current_level)
            dfr = 1'b1;
        else
            dfr = 1'b0;
    end
endmodule