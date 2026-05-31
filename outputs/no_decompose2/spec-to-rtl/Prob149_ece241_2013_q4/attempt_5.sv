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

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    always @(*) begin
        // Reset condition: no sensors asserted, all 4 outputs asserted
        if (reset) begin
            {fr2, fr1, fr0, dfr} = 4'b1111;
        end else begin
            logic prev_higher;
            prev_higher = (prev_s > s);

            case (s)
                3'b111: {fr2, fr1, fr0, dfr} = 4'b0000;
                3'b011: {fr2, fr1, fr0, dfr} = {1'b0, 1'b0, 1'b1, prev_higher};
                3'b001: {fr2, fr1, fr0, dfr} = {1'b0, 1'b1, 1'b1, prev_higher};
                3'b000: {fr2, fr1, fr0, dfr} = {1'b1, 1'b1, 1'b1, 1'b0};
                default: {fr2, fr1, fr0, dfr} = 4'b0000;
            endcase
        end
    end

endmodule
