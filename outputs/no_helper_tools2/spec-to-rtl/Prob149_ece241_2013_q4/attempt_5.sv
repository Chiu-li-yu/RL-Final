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

    // Based on the table:
    // Above s[2]: sensors s[0], s[1], s[2] asserted? No, table says s[2] is above?
    // Wait, table: "Above s[2] | s[0], s[1], s[2] | None"
    // So current_zone depends on s[2], s[1], s[0].
    always @(*) begin
        if (s[2]) current_zone = 2'd3;
        else if (s[1]) current_zone = 2'd2;
        else if (s[0]) current_zone = 2'd1;
        else current_zone = 2'd0;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_zone <= 2'd0;
            fr2 <= 1;
            fr1 <= 1;
            fr0 <= 1;
            dfr <= 1;
        end else begin
            prev_zone <= current_zone;
            
            case (current_zone)
                2'd3: begin
                    fr0 <= 0; fr1 <= 0; fr2 <= 0; dfr <= 0;
                end
                2'd2: begin
                    fr0 <= 1; fr1 <= 0; fr2 <= 0;
                    dfr <= (prev_zone > current_zone);
                end
                2'd1: begin
                    fr0 <= 1; fr1 <= 1; fr2 <= 0;
                    dfr <= (prev_zone > current_zone);
                end
                2'd0: begin
                    fr0 <= 1; fr1 <= 1; fr2 <= 1;
                    dfr <= 0;
                end
            endcase
        end
    end
endmodule
