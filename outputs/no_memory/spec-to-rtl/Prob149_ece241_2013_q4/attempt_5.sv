module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);
    // State representation
    // Level 0: Below s[0] (s=000)
    // Level 1: Between s[0] and s[1] (s=001)
    // Level 2: Between s[1] and s[2] (s=011)
    // Level 3: Above s[2] (s=111)

    logic [1:0] current_level, prev_level;

    // Decode current_level from sensors
    logic [1:0] decoded_level;
    always @(*) begin
        case (s)
            3'b000: decoded_level = 2'd0;
            3'b001: decoded_level = 2'd1;
            3'b011: decoded_level = 2'd2;
            3'b111: decoded_level = 2'd3;
            default: decoded_level = current_level; // Hold if invalid
        endcase
    end

    // Sequential update
    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'd0;
            prev_level <= 2'd0;
        end else if (decoded_level != current_level) begin
            prev_level <= current_level;
            current_level <= decoded_level;
        end
    end

    // Outputs
    // Level 0 (s=000): fr0=1, fr1=1, fr2=1
    // Level 1 (s=001): fr0=1, fr1=1
    // Level 2 (s=011): fr0=1
    // Level 3 (s=111): None
    
    logic f0, f1, f2;
    always @(*) begin
        case (current_level)
            2'd0: begin f0 = 1; f1 = 1; f2 = 1; end
            2'd1: begin f0 = 1; f1 = 1; f2 = 0; end
            2'd2: begin f0 = 1; f1 = 0; f2 = 0; end
            2'd3: begin f0 = 0; f1 = 0; f2 = 0; end
            default: begin f0 = 0; f1 = 0; f2 = 0; end
        endcase
    end

    assign fr0 = f0;
    assign fr1 = f1;
    assign fr2 = f2;

    // dfr logic: "If the sensor change indicates that the previous level was higher than the current level"
    // Reset state: "no sensors asserted, and all four outputs asserted"
    // So on reset, dfr = 1.
    logic d;
    always @(*) begin
        if (reset)
            d = 1;
        else if (current_level < prev_level)
            d = 1;
        else
            d = 0;
    end
    assign dfr = d;

endmodule
