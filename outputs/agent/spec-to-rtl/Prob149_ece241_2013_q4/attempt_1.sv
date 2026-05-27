module TopModule (
    input logic clk,
    input logic reset,
    input logic [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    typedef enum logic [2:0] {
        LEVEL_BELOW = 3'b000,
        LEVEL_S0    = 3'b001,
        LEVEL_S1    = 3'b011,
        LEVEL_S2    = 3'b111
    } level_t;

    level_t current_level, next_level;
    level_t prev_level;

    // Determine current level based on sensors
    always @(*) begin
        case (s)
            3'b000: next_level = LEVEL_BELOW;
            3'b001: next_level = LEVEL_S0;
            3'b011: next_level = LEVEL_S1;
            3'b111: next_level = LEVEL_S2;
            default: next_level = current_level; // Should not happen per spec
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            current_level <= LEVEL_BELOW;
            prev_level <= LEVEL_BELOW;
        end else begin
            if (current_level != next_level) begin
                prev_level <= current_level;
                current_level <= next_level;
            end
        end
    end

    always @(*) begin
        // Nominal flow rate logic
        fr2 = (current_level == LEVEL_BELOW);
        fr1 = (current_level == LEVEL_BELOW || current_level == LEVEL_S0);
        fr0 = (current_level != LEVEL_S2);

        // Supplemental flow logic (dfr)
        // If current level is higher than prev level, supplemental flow is active
        // Spec: "If the sensor change indicates that the previous level was lower than the current level"
        // Meaning: water level rising -> supplemental valve opened
        dfr = (current_level > prev_level);
    end

endmodule
