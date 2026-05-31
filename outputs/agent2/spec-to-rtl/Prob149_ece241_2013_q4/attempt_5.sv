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

    always @(*) begin
        // Reset state: "no sensors asserted, and all four outputs asserted"
        // This is equivalent to Level 0 (no sensors) PLUS dfr=1.
        if (reset) begin
            {fr2, fr1, fr0, dfr} = 4'b1111;
        end else begin
            case (current_level)
                2'd3: {fr2, fr1, fr0} = 3'b000;
                2'd2: {fr2, fr1, fr0} = 3'b001;
                2'd1: {fr2, fr1, fr0} = 3'b011;
                2'd0: {fr2, fr1, fr0} = 3'b111;
                default: {fr2, fr1, fr0} = 3'b000;
            endcase
            
            dfr = (current_level == 2'd0) || (prev_level > current_level);
        end
    end
endmodule