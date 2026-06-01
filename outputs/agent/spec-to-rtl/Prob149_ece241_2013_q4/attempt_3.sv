module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);
    // Sensor interpretation:
    // s[2] s[1] s[0] | Level
    // 1    1    1    | 3 (Above s2)
    // 0    1    1    | 2 (Between s2, s1)
    // 0    0    1    | 1 (Between s1, s0)
    // 0    0    0    | 0 (Below s0)

    logic [1:0] current_level;
    logic [1:0] prev_level;

    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    // Use asynchronous reset behavior for registers by setting their value
    // but the task asks for synchronous reset.
    // Spec: "resets the state machine to a state equivalent to if the water 
    // level had been low for a long time (no sensors asserted, and all four 
    // outputs asserted)."
    // Wait: If I reset, my current_level register (if I had one) or previous state
    // should be 0.
    
    always_ff @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0;
        else
            prev_level <= current_level;
    end

    always @(*) begin
        // Nominal
        fr0 = (current_level <= 2'd2 && current_level >= 2'd0);
        fr1 = (current_level <= 2'd1 && current_level >= 2'd0);
        fr2 = (current_level == 2'd0);
        
        // dfr logic
        // Reset state: no sensors (s=3'b000) => level 0. Outputs: all 4 asserted.
        // If s=0, level 0. Outputs are 1,1,1,1.
        // My previous logic: current_level 0 -> fr2,fr1,fr0 = 1. dfr = 1.
        // This matches.

        if (reset) begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end else begin
            // Supplemental
            dfr = (current_level == 2'd0) || (prev_level > current_level);
        end
    end
endmodule