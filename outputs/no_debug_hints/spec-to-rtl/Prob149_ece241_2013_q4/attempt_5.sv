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

    // Reset logic: "resets the state machine to a state equivalent to 
    // if the water level had been low for a long time (no sensors asserted, 
    // and all four outputs asserted)."
    // So on reset, we want fr2=1, fr1=1, fr0=1, dfr=1.
    // Since nominal flows are combinational based on s, 
    // if we want them to be 1, s must be 3'b000.
    
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    always @(*) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} = 4'b1111;
        end else begin
            case (s)
                3'b111: {fr2, fr1, fr0} = 3'b000;
                3'b011: {fr2, fr1, fr0} = 3'b001;
                3'b001: {fr2, fr1, fr0} = 3'b110; // Wait, check table again: Between 1 and 0: s[0] asserted. Table: s[0] asserted -> fr0, fr1.
                // Re-reading table:
                // Between s[2] and s[1] | s[0], s[1] | fr0
                // Between s[1] and s[0] | s[0]       | fr0, fr1
                // Below s[0]            | None       | fr0, fr1, fr2
                default: {fr2, fr1, fr0} = 3'b111;
            endcase
            
            // Re-check table mapping
            // s[2], s[1], s[0]
            // 3'b111: Above -> None -> 000
            // 3'b011: s[0], s[1] -> fr0 -> 001
            // 3'b001: s[0] -> fr0, fr1 -> 011
            // 3'b000: None -> fr0, fr1, fr2 -> 111

            case (s)
                3'b111: {fr2, fr1, fr0} = 3'b000;
                3'b011: {fr2, fr1, fr0} = 3'b001;
                3'b001: {fr2, fr1, fr0} = 3'b011;
                3'b000: {fr2, fr1, fr0} = 3'b111;
                default: {fr2, fr1, fr0} = 3'b111;
            endcase

            dfr = (s < prev_s);
        end
    end

endmodule
