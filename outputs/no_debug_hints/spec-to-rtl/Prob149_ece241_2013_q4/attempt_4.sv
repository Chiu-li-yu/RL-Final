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
    logic dfr_reg;

    assign dfr = dfr_reg;

    // Nominal flows are combinational based on s
    always @(*) begin
        case (s)
            3'b111: {fr2, fr1, fr0} = 3'b000;
            3'b011: {fr2, fr1, fr0} = 3'b001;
            3'b001: {fr2, fr1, fr0} = 3'b011;
            3'b000: {fr2, fr1, fr0} = 3'b111;
            default: {fr2, fr1, fr0} = 3'b111;
        endcase
    end

    // dfr and prev_s state machine
    always @(posedge clk) begin
        if (reset) begin
            prev_s  <= 3'b000;
            dfr_reg <= 1'b1;
        end else begin
            prev_s <= s;
            // "If the sensor change indicates that the previous level was higher than current,
            // the flow rate should be increased by opening the Supplemental flow valve (dfr)"
            // Also need to check if the state is NOT the lowest state (Below s[0])? 
            // Actually the prompt says "The flow rate when the level is between... is determined by two factors"
            // Let's implement the logic: dfr = (s < prev_s)
            dfr_reg <= (s < prev_s);
        end
    end

endmodule
