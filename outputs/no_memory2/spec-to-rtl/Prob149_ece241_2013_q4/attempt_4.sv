module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // States representing water level
    // ABOVE_S2: Above s[2]
    // S2_S1: Between s[2] and s[1]
    // S1_S0: Between s[1] and s[0]
    // BELOW_S0: Below s[0]
    localparam [1:0] ABOVE_S2 = 2'd3, S2_S1 = 2'd2, S1_S0 = 2'd1, BELOW_S0 = 2'd0;

    logic [1:0] current_level, next_level, prev_level;

    // Decode current sensor input to state
    always @(*) begin
        if (s == 3'b111) next_level = ABOVE_S2;
        else if (s == 3'b011) next_level = S2_S1;
        else if (s == 3'b001) next_level = S1_S0;
        else next_level = BELOW_S0;
    end

    // Sequential update of states
    always @(posedge clk) begin
        if (reset) begin
            current_level <= BELOW_S0;
            prev_level <= BELOW_S0;
        end else begin
            prev_level <= current_level;
            current_level <= next_level;
        end
    end

    // Logic for outputs fr2, fr1, fr0 based on current_level
    assign fr2 = (current_level == BELOW_S0);
    assign fr1 = (current_level == BELOW_S0) || (current_level == S1_S0);
    assign fr0 = (current_level == BELOW_S0) || (current_level == S1_S0) || (current_level == S2_S1);

    // dfr: opened if previous level was higher than current level
    // ABOVE_S2 (3) > S2_S1 (2) > S1_S0 (1) > BELOW_S0 (0)
    assign dfr = (prev_level > current_level);

endmodule
