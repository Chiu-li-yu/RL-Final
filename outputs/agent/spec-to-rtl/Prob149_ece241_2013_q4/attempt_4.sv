module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);
    logic [1:0] current_level;
    logic [1:0] prev_level;

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

    // Use Moore-like FSM (outputs only depend on current_level and prev_level)
    always @(*) begin
        // Nominal
        case (current_level)
            2'd3: {fr2, fr1, fr0} = 3'b000;
            2'd2: {fr2, fr1, fr0} = 3'b001;
            2'd1: {fr2, fr1, fr0} = 3'b011;
            2'd0: {fr2, fr1, fr0} = 3'b111;
            default: {fr2, fr1, fr0} = 3'b000;
        endcase

        // Supplemental
        if (reset)
            dfr = 1'b1;
        else if (current_level == 2'd0)
            dfr = 1'b1;
        else if (prev_level > current_level)
            dfr = 1'b1;
        else
            dfr = 1'b0;
    end
endmodule