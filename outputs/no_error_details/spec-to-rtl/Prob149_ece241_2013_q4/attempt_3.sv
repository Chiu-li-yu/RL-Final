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
    logic r_dfr;

    // Water level detection
    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    // Nominal flows: Based on CURRENT level
    assign fr2 = (current_level == 2'd0);
    assign fr1 = (current_level == 2'd0 || current_level == 2'd1);
    assign fr0 = (current_level == 2'd0 || current_level == 2'd1 || current_level == 2'd2);

    // DFR: Based on level change (if previous > current)
    assign dfr = r_dfr;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
            r_dfr <= 1'b1;
        end else begin
            // Check if level decreased
            if (prev_level > current_level)
                r_dfr <= 1'b1;
            else
                r_dfr <= 1'b0;
            prev_level <= current_level;
        end
    end
endmodule