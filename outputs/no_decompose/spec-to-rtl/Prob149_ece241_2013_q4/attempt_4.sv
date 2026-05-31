module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // The sensors indicate level directly.
    // The previous state should be the "level previous to the last sensor change".
    // "Each water level has a nominal flow rate ... If the sensor change indicates 
    // that the previous level was higher than the current level, dfr=1."

    logic [1:0] prev_level;
    logic [1:0] current_level;

    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    // Use current level for output, update prev_level only when current_level changes
    always_ff @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0; // Reset to "low for a long time"
        else if (current_level != prev_level)
            prev_level <= current_level;
    end

    // Outputs are strictly dependent on current level and change flag
    always @(*) begin
        case (current_level)
            2'd3: {fr2, fr1, fr0} = 3'b000;
            2'd2: {fr2, fr1, fr0} = 3'b001;
            2'd1: {fr2, fr1, fr0} = 3'b011;
            2'd0: {fr2, fr1, fr0} = 3'b111;
            default: {fr2, fr1, fr0} = 3'b000;
        endcase

        // If sensor change indicates previous > current, dfr=1.
        // Wait, the logic is: "If the sensor change indicates that the previous level was higher than the current level"
        // This implies dfr should be 1 if current_level changed AND previous was > current.
        if (prev_level > current_level)
            dfr = 1'b1;
        else
            dfr = 1'b0;
    end
endmodule
