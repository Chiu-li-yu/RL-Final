module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    logic [1:0] current_state;
    logic [1:0] prev_state;

    // Based on the spec:
    // Below s[0]: None -> state 0
    // s[0]: s[0] -> state 1
    // Between s[1] and s[0]: s[0], s[1] -> state 2
    // Above s[2]: s[0], s[1], s[2] -> state 3
    
    // Actually looking at table:
    // Above s[2] | s[0], s[1], s[2] -> 3'b111
    // Between s[2] and s[1] | s[0], s[1] -> 3'b011
    // Between s[1] and s[0] | s[0] -> 3'b001
    // Below s[0] | None -> 3'b000
    
    logic [1:0] state_now;
    always @(*) begin
        if (s == 3'b111) state_now = 2'd3;
        else if (s == 3'b011) state_now = 2'd2;
        else if (s == 3'b001) state_now = 2'd1;
        else state_now = 2'd0;
    end

    always @(posedge clk) begin
        if (reset) begin
            current_state <= 2'd0;
            prev_state <= 2'd0;
        end else begin
            prev_state <= current_state;
            current_state <= state_now;
        end
    end

    always @(*) begin
        // Nominal
        fr2 = (current_state == 2'd0);
        fr1 = (current_state == 2'd0 || current_state == 2'd1);
        fr0 = (current_state == 2'd0 || current_state == 2'd1 || current_state == 2'd2);
        
        // Supplemental dfr
        // "If the sensor change indicates that the previous level was higher than the current level"
        // Wait, "previous level was higher than current" means the level is DROPPING.
        // Current state < prev_state means water level is dropping.
        if (reset) dfr = 1;
        else if (current_state < prev_state) dfr = 1;
        else dfr = 0;
    end

endmodule