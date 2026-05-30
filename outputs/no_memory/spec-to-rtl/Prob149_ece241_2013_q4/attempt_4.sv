module TopModule (
    input logic clk,
    input logic reset,
    input logic [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // Current level encoding: 
    // 0: s=000 (Below s[0])
    // 1: s=001 (Between s[1] and s[0])
    // 2: s=011 (Between s[2] and s[1])
    // 3: s=111 (Above s[2])
    logic [1:0] current_level, prev_level;

    always @(*) begin
        case (s)
            3'b000: current_level = 2'd0;
            3'b001: current_level = 2'd1;
            3'b011: current_level = 2'd2;
            3'b111: current_level = 2'd3;
            default: current_level = 2'd0; // Should not happen based on specs
        endcase
    end

    always @(*) begin
        // Default values for nominal flow
        fr2 = 0; fr1 = 0; fr0 = 0;
        case (current_level)
            2'd0: begin fr2 = 1; fr1 = 1; fr0 = 1; end
            2'd1: begin fr2 = 0; fr1 = 1; fr0 = 1; end
            2'd2: begin fr2 = 0; fr1 = 0; fr0 = 1; end
            2'd3: begin fr2 = 0; fr1 = 0; fr0 = 0; end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
            dfr <= 1; // Specification says "all four outputs asserted"
        end else begin
            // If the sensor indicates a change, update history
            // Actually, the spec says "previous level was higher than current level"
            // We update prev_level when current_level changes
            if (s == 3'b000 || s == 3'b001 || s == 3'b011 || s == 3'b111) begin
               if (current_level != prev_level) begin
                   dfr <= (prev_level > current_level);
                   prev_level <= current_level;
               end
            end
        end
    end

endmodule
