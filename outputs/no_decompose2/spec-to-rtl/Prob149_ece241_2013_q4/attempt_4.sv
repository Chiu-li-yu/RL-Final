module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // According to the specification:
    // "active-high synchronous reset that resets the state machine to a state 
    // equivalent to if the water level had been low for a long time 
    // (no sensors asserted, and all four outputs asserted)."
    // Wait, the table says Below s[0] (no sensors asserted) implies fr0, fr1, fr2.
    // The reset says "all four outputs asserted" (fr2, fr1, fr0, dfr).

    logic [2:0] prev_s;
    logic [3:0] outputs;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    always @(*) begin
        if (reset) begin
            outputs = 4'b1111; // fr2, fr1, fr0, dfr asserted
        end else begin
            logic prev_higher;
            prev_higher = (prev_s > s);

            case (s)
                3'b111: outputs = 4'b0000; // Above s[2]
                3'b011: outputs = {1'b0, 1'b0, 1'b1, prev_higher}; // Between s[2] and s[1]
                3'b001: outputs = {1'b0, 1'b1, 1'b1, prev_higher}; // Between s[1] and s[0]
                3'b000: outputs = {1'b1, 1'b1, 1'b1, 1'b0};         // Below s[0]
                default: outputs = 4'b0000;
            endcase
        end
    end

    assign {fr2, fr1, fr0, dfr} = outputs;

endmodule
