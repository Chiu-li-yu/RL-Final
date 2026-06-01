module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);
    // Level encoding
    // Level 3: Above s[2] (s == 3'b111)
    // Level 2: s[2] and s[1] (s == 3'b011)
    // Level 1: s[0] only (s == 3'b001)
    // Level 0: None (s == 3'b000)
    
    logic [1:0] current_level, prev_level;

    always @(*) begin
        case (s)
            3'b111: current_level = 2'd3;
            3'b011: current_level = 2'd2;
            3'b001: current_level = 2'd1;
            default: current_level = 2'd0;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0;
        else
            prev_level <= current_level;
    end

    always @(*) begin
        // Nominal Flow Rates
        case (current_level)
            2'd3: {fr2, fr1, fr0} = 3'b000;
            2'd2: {fr2, fr1, fr0} = 3'b001;
            2'd1: {fr2, fr1, fr0} = 3'b011;
            2'd0: {fr2, fr1, fr0} = 3'b111;
            default: {fr2, fr1, fr0} = 3'b000;
        endcase
        
        // dfr logic: if previous level > current level, dfr = 1
        if (prev_level > current_level)
            dfr = 1'b1;
        else
            dfr = (current_level == 2'd0) ? 1'b1 : 1'b0;
    end
endmodule