module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);
    logic [1:0] current_level;
    logic [1:0] prev_level;

    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    assign fr2 = (current_level == 2'd0);
    assign fr1 = (current_level == 2'd0 || current_level == 2'd1);
    assign fr0 = (current_level == 2'd0 || current_level == 2'd1 || current_level == 2'd2);

    // DFR logic: 
    // If level drops (prev > current), dfr = 1.
    // Reset state: "Below s[0]" (level 0), all outputs = 1.
    // So if reset, dfr = 1.
    // Note: If I use combinatorial output, it might not match reset behavior perfectly 
    // if "all four outputs asserted" means it *stays* at 1 for the first cycle.
    
    logic dfr_reg;
    assign dfr = dfr_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
            dfr_reg <= 1'b1;
        end else begin
            prev_level <= current_level;
            if (prev_level > current_level)
                dfr_reg <= 1'b1;
            else
                dfr_reg <= 1'b0;
        end
    end
endmodule