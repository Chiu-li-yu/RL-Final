module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);
    logic [2:0] state;
    logic [2:0] prev_state;

    // reset: state 000, outputs 1,1,1,1
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            prev_state <= 3'b000;
        end else if (s != state) begin
            prev_state <= state;
            state <= s;
        end
    end

    // fr outputs based on current state
    assign fr2 = (state == 3'b000);
    assign fr1 = (state == 3'b000 || state == 3'b001);
    assign fr0 = (state == 3'b000 || state == 3'b001 || state == 3'b011);

    // dfr logic:
    // If reset, dfr=1. 
    // If state changes, dfr = (prev_state > state).
    // Otherwise dfr should hold/update based on specific logic? 
    // The problem says "previous to the last sensor change".
    // Let's use a register for dfr.
    logic dfr_val;
    always_ff @(posedge clk) begin
        if (reset) dfr_val <= 1'b1;
        else if (s != state) dfr_val <= (state > s);
        else dfr_val <= 1'b0;
    end
    assign dfr = dfr_val;

endmodule
