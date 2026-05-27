module TopModule (
    input logic clk,
    input logic reset,
    input logic [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // Levels: 0=Below s[0], 1=Between s[0] and s[1], 2=Between s[1] and s[2], 3=Above s[2]
    typedef enum logic [1:0] {
        BELOW_S0 = 2'b00,
        BETWEEN_S0_S1 = 2'b01,
        BETWEEN_S1_S2 = 2'b10,
        ABOVE_S2 = 2'b11
    } level_t;

    level_t current_level, next_level, prev_level;

    // Determine current level based on sensor readings
    always @(*) begin
        if (s == 3'b111) current_level = ABOVE_S2;
        else if (s == 3'b011) current_level = BETWEEN_S1_S2;
        else if (s == 3'b001) current_level = BETWEEN_S0_S1;
        else current_level = BELOW_S0;
    end

    // Sequential logic for prev_level
    always_ff @(posedge clk) begin
        if (reset) begin
            prev_level <= BELOW_S0;
        end else begin
            if (current_level != prev_level) begin
                prev_level <= current_level;
            end
        end
    end

    // Combinational logic for outputs
    always @(*) begin
        // Reset state: no sensors asserted (implied level 0), all outputs asserted
        if (reset) begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end else begin
            // Default nominal flow logic based on current level
            case (current_level)
                ABOVE_S2: begin
                    fr0 = 1'b0; fr1 = 1'b0; fr2 = 1'b0;
                end
                BETWEEN_S1_S2: begin
                    fr0 = 1'b1; fr1 = 1'b0; fr2 = 1'b0;
                end
                BETWEEN_S0_S1: begin
                    fr0 = 1'b1; fr1 = 1'b1; fr2 = 1'b0;
                end
                BELOW_S0: begin
                    fr0 = 1'b1; fr1 = 1'b1; fr2 = 1'b1;
                end
                default: begin
                    fr0 = 1'b1; fr1 = 1'b1; fr2 = 1'b1;
                end
            endcase

            // dfr (Supplemental flow valve) logic: 
            // If the sensor change indicates the previous level was lower than current, dfr = 1.
            if (current_level > prev_level) begin
                dfr = 1'b1;
            end else begin
                dfr = 1'b0;
            end
        end
    end

endmodule
