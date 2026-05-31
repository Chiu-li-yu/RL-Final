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

    // Determine current level based on sensor pattern
    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    // Nominal flow outputs (Moore-like)
    assign fr2 = (current_level == 2'd0);
    assign fr1 = (current_level == 2'd0 || current_level == 2'd1);
    assign fr0 = (current_level == 2'd0 || current_level == 2'd1 || current_level == 2'd2);

    // DFR logic: Supplemental flow if current_level < prev_level (Mealy-like)
    // Synchronous reset sets state to 'Below s[0]' (level 0)
    // "all four outputs asserted" means when reset, outputs are 1.
    // Level 0 has outputs 1, 1, 1, and since reset makes previous = current = 0, we need to handle the state.
    
    logic r_dfr;
    assign dfr = r_dfr;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
            r_dfr <= 1'b1; 
        end else begin
            if (current_level < prev_level)
                r_dfr <= 1'b1;
            else
                r_dfr <= 1'b0;
            prev_level <= current_level;
        end
    end
endmodule