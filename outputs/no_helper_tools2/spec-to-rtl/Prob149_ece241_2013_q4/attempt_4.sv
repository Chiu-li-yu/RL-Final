module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    logic [1:0] prev_zone;
    logic [1:0] current_zone;

    always @(*) begin
        if (s[2] && s[1] && s[0]) current_zone = 2'd3;
        else if (s[1] && s[0])    current_zone = 2'd2;
        else if (s[0])            current_zone = 2'd1;
        else                      current_zone = 2'd0;
    end

    // Use synchronous updates for outputs
    always_ff @(posedge clk) begin
        if (reset) begin
            prev_zone <= 2'd0;
            fr2 <= 1;
            fr1 <= 1;
            fr0 <= 1;
            dfr <= 1;
        end else begin
            prev_zone <= current_zone;
            
            // Re-evaluate current outputs based on current state logic
            // Flow table:
            // Below s[0]: s=000 -> fr0, fr1, fr2
            // Between s[1],s[0]: s=001 -> fr0, fr1, (dfr if prev was higher)
            // Between s[2],s[1]: s=011 -> fr0, (dfr if prev was higher)
            // Above s[2]: s=111 -> None
            
            case (current_zone)
                2'd3: begin // Above s[2]
                    fr0 <= 0; fr1 <= 0; fr2 <= 0; dfr <= 0;
                end
                2'd2: begin // Between s[2] and s[1]
                    fr0 <= 1; fr1 <= 0; fr2 <= 0;
                    dfr <= (prev_zone > current_zone) ? 1 : 0;
                end
                2'd1: begin // Between s[1] and s[0]
                    fr0 <= 1; fr1 <= 1; fr2 <= 0;
                    dfr <= (prev_zone > current_zone) ? 1 : 0;
                end
                2'd0: begin // Below s[0]
                    fr0 <= 1; fr1 <= 1; fr2 <= 1;
                    dfr <= 0; 
                end
            endcase
        end
    end
endmodule
