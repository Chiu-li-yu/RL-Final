module TopModule (
    input logic clk,
    input logic reset,
    input logic [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);
    // The previous level is the level the system was in *before* the last sensor change.
    // The reset condition: "resets the state machine to a state equivalent to if the 
    // water level had been low for a long time (no sensors asserted, and all four outputs asserted)."
    
    logic [2:0] current_level, prev_level;

    // Map sensors to levels
    logic [2:0] sensor_level;
    always @(*) begin
        case (s)
            3'b000: sensor_level = 3'b000;
            3'b001: sensor_level = 3'b001;
            3'b011: sensor_level = 3'b010;
            3'b111: sensor_level = 3'b011;
            default: sensor_level = current_level;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            current_level <= 3'b000;
            prev_level    <= 3'b000;
        end else if (sensor_level != current_level) begin
            prev_level    <= current_level;
            current_level <= sensor_level;
        end
    end

    always @(*) begin
        if (reset) begin
            fr2 = 1;
            fr1 = 1;
            fr0 = 1;
            dfr = 1;
        end else begin
            // Levels: 0 (below), 1 (s0), 2 (s1), 3 (s2)
            case (current_level)
                3'b000: {fr2, fr1, fr0} = 3'b111;
                3'b001: {fr2, fr1, fr0} = 3'b011;
                3'b010: {fr2, fr1, fr0} = 3'b001;
                3'b011: {fr2, fr1, fr0} = 3'b000;
                default: {fr2, fr1, fr0} = 3'b000;
            endcase
            
            // "If the sensor change indicates that the previous level was lower than the current level"
            // Rising: current_level > prev_level
            dfr = (current_level > prev_level);
        end
    end
endmodule
