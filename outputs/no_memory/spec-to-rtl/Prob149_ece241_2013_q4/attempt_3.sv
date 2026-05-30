module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // Represent levels as: 0: Below s[0], 1: Between s[1] and s[0], 2: Between s[2] and s[1], 3: Above s[2]
    logic [1:0] current_level, prev_level;

    always @(*) begin
        case (s)
            3'b000: current_level = 2'd0;
            3'b001: current_level = 2'd1;
            3'b011: current_level = 2'd2;
            3'b111: current_level = 2'd3;
            default: current_level = 2'd0; // Should not happen given problem constraints
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
        end else if (current_level != prev_level) begin
            prev_level <= current_level;
        end
    end

    always @(*) begin
        if (reset) begin
            fr0 = 1'b1;
            fr1 = 1'b1;
            fr2 = 1'b1;
            dfr = 1'b1;
        end else begin
            case (current_level)
                2'd3: begin // Above s[2]
                    fr0 = 1'b0; fr1 = 1'b0; fr2 = 1'b0;
                end
                2'd2: begin // Between s[2] and s[1]
                    fr0 = 1'b1; fr1 = 1'b0; fr2 = 1'b0;
                end
                2'd1: begin // Between s[1] and s[0]
                    fr0 = 1'b1; fr1 = 1'b1; fr2 = 1'b0;
                end
                2'd0: begin // Below s[0]
                    fr0 = 1'b1; fr1 = 1'b1; fr2 = 1'b1;
                end
                default: begin
                    fr0 = 1'b0; fr1 = 1'b0; fr2 = 1'b0;
                end
            endcase
            // Supplemental flow: if prev_level > current_level
            dfr = (prev_level > current_level) ? 1'b1 : 1'b0;
        end
    end

endmodule
