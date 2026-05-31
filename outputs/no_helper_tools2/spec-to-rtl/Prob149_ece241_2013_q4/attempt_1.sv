module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // State represents the previous water level zone
    // 0: Below s[0]
    // 1: Between s[1] and s[0]
    // 2: Between s[2] and s[1]
    // 3: Above s[2]
    logic [1:0] prev_zone;

    logic [1:0] current_zone;

    always @(*) begin
        if (s[2]) current_zone = 2'd3;
        else if (s[1]) current_zone = 2'd2;
        else if (s[0]) current_zone = 2'd1;
        else current_zone = 2'd0;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_zone <= 2'd0;
        end else begin
            prev_zone <= current_zone;
        end
    end

    always @(*) begin
        // Default values
        fr0 = 0; fr1 = 0; fr2 = 0; dfr = 0;

        case (current_zone)
            2'd3: begin // Above s[2]
                fr0 = 0; fr1 = 0; fr2 = 0; dfr = 0;
            end
            2'd2: begin // Between s[2] and s[1]
                fr0 = 1; fr1 = 0; fr2 = 0;
                dfr = (prev_zone > current_zone) ? 1 : 0;
            end
            2'd1: begin // Between s[1] and s[0]
                fr0 = 1; fr1 = 1; fr2 = 0;
                dfr = (prev_zone > current_zone) ? 1 : 0;
            end
            2'd0: begin // Below s[0]
                fr0 = 1; fr1 = 1; fr2 = 1; dfr = 0;
            end
        endcase
    end
endmodule
