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

    // Define state from sensors
    logic [1:0] s_encoded;
    always @(*) begin
        case (s)
            3'b000: s_encoded = 2'd0;
            3'b001: s_encoded = 2'd1;
            3'b011: s_encoded = 2'd2;
            3'b111: s_encoded = 2'd3;
            default: s_encoded = 2'd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            current_state <= 2'd0;
            prev_state <= 2'd0;
        end else begin
            prev_state <= current_state;
            current_state <= s_encoded;
        end
    end

    // Outputs
    // The outputs should be based on the sensors, not strictly a state machine
    // Wait, the spec says "The flow rate... is determined by two factors: the water level AND the level previous to the last sensor change."
    // This implies a Mealy machine where outputs are function of current sensors and state.

    always @(*) begin
        // Nominal Flow
        // Below s[0] (s=000): fr2, fr1, fr0
        // s[0] (s=001): fr1, fr0
        // s[0], s[1] (s=011): fr0
        // s[0], s[1], s[2] (s=111): None
        
        fr2 = (s == 3'b000);
        fr1 = (s == 3'b000 || s == 3'b001);
        fr0 = (s == 3'b000 || s == 3'b001 || s == 3'b011);
        
        // Supplemental dfr
        // "If the sensor change indicates that the previous level was higher than the current level"
        // Previous level stored in prev_state.
        if (reset) dfr = 1;
        else if (current_state < prev_state) dfr = 1;
        else dfr = 0;
    end

endmodule