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

    // Synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Combinational logic for outputs
    always @(*) begin
        // Reset state: no sensors asserted, all four outputs asserted
        if (reset) begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end else begin
            // Water Level | Sensors Asserted | Nominal Flow Rate
            // Above s[2]   | s[0], s[1], s[2] | None (fr2,1,0 = 0)
            // Btw s[2],s[1]| s[0], s[1]       | fr0 (fr2,1=0, fr0=1)
            // Btw s[1],s[0]| s[0]             | fr0, fr1 (fr2=0, fr0,1=1)
            // Below s[0]   | None             | fr0, fr1, fr2 (fr0,1,2=1)

            // s[2] corresponds to highest sensor, s[0] to lowest.
            // The table implies binary value 3'b111 = Above, 3'b011 = Btw 2/1, 3'b001 = Btw 1/0, 3'b000 = Below
            case (s)
                3'b111: {fr2, fr1, fr0} = 3'b000;
                3'b011: {fr2, fr1, fr0} = 3'b001;
                3'b001: {fr2, fr1, fr0} = 3'b011;
                3'b000: {fr2, fr1, fr0} = 3'b111;
                default: {fr2, fr1, fr0} = 3'b111;
            endcase

            // dfr: opened if previous level was higher than current
            // (s < prev_s)
            dfr = (s < prev_s);
        end
    end

endmodule
