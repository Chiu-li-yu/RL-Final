module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Current Water Level State based on sensors
    // State 3: Above s[2] (s=111)
    // State 2: Between s[2] and s[1] (s=011)
    // State 1: Between s[1] and s[0] (s=001)
    // State 0: Below s[0] (s=000)

    logic [1:0] current_level;
    logic [1:0] prev_level;

    always @(*) begin
        case (s)
            3'b111: current_level = 2'd3;
            3'b011: current_level = 2'd2;
            3'b001: current_level = 2'd1;
            3'b000: current_level = 2'd0;
            default: current_level = 2'd0; // Should not happen based on description
        endcase
    end

    // Sequential logic for state and prev_level
    logic [1:0] state_reg, prev_reg;
    always_ff @(posedge clk) begin
        if (reset) begin
            state_reg <= 2'd0;
            prev_reg <= 2'd0;
        end else begin
            if (s == 3'b111 || s == 3'b011 || s == 3'b001 || s == 3'b000) begin
                if (current_level != state_reg) begin
                    prev_reg <= state_reg;
                    state_reg <= current_level;
                end
            end
        end
    end

    // Output logic
    logic n_fr2, n_fr1, n_fr0, n_dfr;

    always @(*) begin
        // Nominal Flow Rate
        case (current_level)
            2'd3: {n_fr2, n_fr1, n_fr0} = 3'b000;
            2'd2: {n_fr2, n_fr1, n_fr0} = 3'b001;
            2'd1: {n_fr2, n_fr1, n_fr0} = 3'b011;
            2'd0: {n_fr2, n_fr1, n_fr0} = 3'b111;
            default: {n_fr2, n_fr1, n_fr0} = 3'b000;
        endcase

        // Supplemental flow (dfr)
        // If previous level was higher than current level, open dfr
        if (prev_reg > current_level)
            n_dfr = 1'b1;
        else if (current_level == 2'd0)
            n_dfr = 1'b1; // Per reset condition/low water definition
        else
            n_dfr = 1'b0;
    end

    assign fr2 = n_fr2;
    assign fr1 = n_fr1;
    assign fr0 = n_fr0;
    assign dfr = n_dfr;

endmodule