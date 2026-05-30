module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Represent levels as: 3 (Above s2), 2 (s2-s1), 1 (s1-s0), 0 (Below s0)
    logic [1:0] current_level, prev_level;

    always_comb begin
        case (s)
            3'b111: current_level = 2'd3;
            3'b011: current_level = 2'd2;
            3'b001: current_level = 2'd1;
            default: current_level = 2'd0;
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
        end else begin
            prev_level <= current_level;
        end
    end

    assign fr0 = (current_level >= 2'd1);
    assign fr1 = (current_level >= 2'd2);
    assign fr2 = (current_level >= 2'd3);
    
    // Supplemental flow: if current level < previous level, dfr=1.
    // Also, when reset, the requirement states all outputs asserted.
    // Level 0 is the lowest. If level was "low for a long time", 
    // it implies the state is 0.
    
    logic dfr_reg;
    always_ff @(posedge clk) begin
        if (reset) begin
            dfr_reg <= 1'b1;
        end else begin
            if (current_level < prev_level)
                dfr_reg <= 1'b1;
            else
                dfr_reg <= 1'b0;
        end
    end

    assign dfr = (reset) ? 1'b1 : dfr_reg;

endmodule
