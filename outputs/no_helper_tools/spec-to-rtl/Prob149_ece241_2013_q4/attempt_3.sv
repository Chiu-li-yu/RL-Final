module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

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
        // Nominal flow
        case (current_level)
            2'd3: {fr2, fr1, fr0} = 3'b000;
            2'd2: {fr2, fr1, fr0} = 3'b001;
            2'd1: {fr2, fr1, fr0} = 3'b011;
            default: {fr2, fr1, fr0} = 3'b111;
        endcase

        // Supplemental flow
        if (current_level == 2'd3 || current_level == 2'd0)
            dfr = 0;
        else if (prev_level > current_level)
            dfr = 1;
        else
            dfr = 0;
            
        // Reset overrides
        if (reset) {fr2, fr1, fr0, dfr} = 4'b1111;
    end

endmodule
