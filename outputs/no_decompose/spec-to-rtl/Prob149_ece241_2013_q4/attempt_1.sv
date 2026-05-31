module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // State definition: Represents the previous water level
    // 3'b000: Below s0
    // 3'b001: Between s0 and s1
    // 3'b011: Between s1 and s2
    // 3'b111: Above s2
    logic [2:0] prev_level, next_level;

    always_ff @(posedge clk) begin
        if (reset)
            prev_level <= 3'b000;
        else
            prev_level <= next_level;
    end

    always @(*) begin
        // Determine current level based on sensors
        if (s == 3'b111) next_level = 3'b111;
        else if (s == 3'b011) next_level = 3'b011;
        else if (s == 3'b001) next_level = 3'b001;
        else next_level = 3'b000;
    end

    always @(*) begin
        // Default outputs
        fr0 = 0; fr1 = 0; fr2 = 0; dfr = 0;

        // Determine nominal flow based on current level
        case (next_level)
            3'b111: begin fr0 = 0; fr1 = 0; fr2 = 0; end
            3'b011: begin fr0 = 1; fr1 = 0; fr2 = 0; end
            3'b001: begin fr0 = 1; fr1 = 1; fr2 = 0; end
            3'b000: begin fr0 = 1; fr1 = 1; fr2 = 1; end
            default: begin fr0 = 0; fr1 = 0; fr2 = 0; end
        endcase

        // Determine Supplemental flow (dfr)
        // If previous level was higher than current level, set dfr = 1
        if (prev_level > next_level)
            dfr = 1;
    end
endmodule
