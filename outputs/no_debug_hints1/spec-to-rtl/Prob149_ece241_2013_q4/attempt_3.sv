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

    // Output registers to ensure synchronous behavior
    logic fr2_r, fr1_r, fr0_r, dfr_r;

    assign fr2 = fr2_r;
    assign fr1 = fr1_r;
    assign fr0 = fr0_r;
    assign dfr = dfr_r;

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            fr2_r  <= 1'b1;
            fr1_r  <= 1'b1;
            fr0_r  <= 1'b1;
            dfr_r  <= 1'b1;
        end else begin
            prev_s <= s;
            
            // Logic calculation
            case (s)
                3'b111: {fr2_r, fr1_r, fr0_r} <= 3'b000;
                3'b011: {fr2_r, fr1_r, fr0_r} <= 3'b001;
                3'b001: {fr2_r, fr1_r, fr0_r} <= 3'b011;
                3'b000: {fr2_r, fr1_r, fr0_r} <= 3'b111;
                default: {fr2_r, fr1_r, fr0_r} <= 3'b111;
            endcase
            
            dfr_r <= (s < prev_s);
        end
    end

endmodule
