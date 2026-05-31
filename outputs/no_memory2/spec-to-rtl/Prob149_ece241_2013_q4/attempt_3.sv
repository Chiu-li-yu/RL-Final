module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Represent state by the sensor value
    logic [2:0] prev_s;

    // Synchronous logic to store previous state
    always_ff @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Combinational logic for outputs
    always_comb begin
        if (reset) begin
            // Reset state: Below s[0] (s=000)
            // Outputs: fr2=1, fr1=1, fr0=1, dfr=0
            {fr2, fr1, fr0, dfr} = 4'b1110;
        end else begin
            case (s)
                3'b111: begin // Above s[2]
                    {fr2, fr1, fr0} = 3'b000;
                    dfr = 0;
                end
                3'b011: begin // Between s[2] and s[1]
                    {fr2, fr1, fr0} = 3'b001;
                    dfr = (prev_s > s) ? 1'b1 : 1'b0;
                end
                3'b001: begin // Between s[1] and s[0]
                    {fr2, fr1, fr0} = 3'b011;
                    dfr = (prev_s > s) ? 1'b1 : 1'b0;
                end
                3'b000: begin // Below s[0]
                    {fr2, fr1, fr0} = 3'b111;
                    dfr = 0;
                end
                default: begin
                    {fr2, fr1, fr0} = 3'b111;
                    dfr = 0;
                end
            endcase
        end
    end

endmodule