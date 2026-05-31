module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    logic [2:0] prev_s;

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    always @(*) begin
        if (reset) begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end else begin
            // Determine nominal flow rates based on current sensors
            case (s)
                3'b111: begin // Above s[2]
                    fr0 = 1'b0;
                    fr1 = 1'b0;
                    fr2 = 1'b0;
                end
                3'b011: begin // Between s[2] and s[1]
                    fr0 = 1'b1;
                    fr1 = 1'b0;
                    fr2 = 1'b0;
                end
                3'b001: begin // Between s[1] and s[0]
                    fr0 = 1'b1;
                    fr1 = 1'b1;
                    fr2 = 1'b0;
                end
                3'b000: begin // Below s[0]
                    fr0 = 1'b1;
                    fr1 = 1'b1;
                    fr2 = 1'b1;
                end
                default: begin // Default case (should not happen based on specs, but good practice)
                    fr0 = 1'b1;
                    fr1 = 1'b1;
                    fr2 = 1'b1;
                end
            endcase

            // Determine dfr: 
            // "If the sensor change indicates that the previous level was 
            // higher than the current level, the flow rate should be increased"
            // Assuming higher binary value means higher water level.
            if (s < prev_s) begin
                dfr = 1'b1;
            end else begin
                dfr = 1'b0;
            end
        end
    end

endmodule
