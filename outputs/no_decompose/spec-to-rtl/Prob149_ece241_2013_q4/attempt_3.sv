module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    logic [1:0] prev_level;

    // reset condition: "no sensors asserted, and all four outputs asserted"
    // No sensors asserted means s = 000.
    // If the reset forces state to "low for a long time", maybe prev_level should be set to 0.
    // The outputs are all asserted when below s[0] (level 0).

    always_ff @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0;
        else begin
            if (s == 3'b111) prev_level <= 2'd3;
            else if (s == 3'b011) prev_level <= 2'd2;
            else if (s == 3'b001) prev_level <= 2'd1;
            else prev_level <= 2'd0;
        end
    end

    logic [1:0] current_level;
    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    always @(*) begin
        // Nominal flow
        case (current_level)
            2'd3: {fr2, fr1, fr0} = 3'b000;
            2'd2: {fr2, fr1, fr0} = 3'b001;
            2'd1: {fr2, fr1, fr0} = 3'b011;
            2'd0: {fr2, fr1, fr0} = 3'b111;
            default: {fr2, fr1, fr0} = 3'b000;
        endcase

        // Supplemental flow (dfr)
        // If the previous level was higher than current level, open dfr
        // BUT also check if it's currently low (not 3'b111)
        if (prev_level > current_level && current_level < 2'd3)
            dfr = 1'b1;
        else
            dfr = 1'b0;
    end
endmodule
