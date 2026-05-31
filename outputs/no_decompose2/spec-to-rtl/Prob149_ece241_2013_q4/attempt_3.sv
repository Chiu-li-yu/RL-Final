module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // State encoding:
    // S3: 3'b111 (Above s[2])
    // S2: 3'b011 (Between s[2] and s[1])
    // S1: 3'b001 (Between s[1] and s[0])
    // S0: 3'b000 (Below s[0])

    logic [2:0] state, next_state;
    logic [2:0] prev_s;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            prev_s <= 3'b000;
        end else begin
            state <= s;
            prev_s <= state;
        end
    end

    always @(*) begin
        // The problem states: "If the sensor change indicates that the previous level was higher than the current level, 
        // the flow rate should be increased by opening the Supplemental flow valve (controlled by dfr)."
        // "Previous level was higher" = prev_s > s
        
        logic prev_higher;
        prev_higher = (prev_s > s);

        case (s)
            3'b111: {fr2, fr1, fr0, dfr} = 4'b0000;
            3'b011: {fr2, fr1, fr0, dfr} = {1'b0, 1'b0, 1'b1, prev_higher};
            3'b001: {fr2, fr1, fr0, dfr} = {1'b0, 1'b1, 1'b1, prev_higher};
            3'b000: {fr2, fr1, fr0, dfr} = {1'b1, 1'b1, 1'b1, 1'b0};
            default: {fr2, fr1, fr0, dfr} = 4'b1110; // Default or hold
        endcase
    end

endmodule
