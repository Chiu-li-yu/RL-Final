module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);
    logic [1:0] current_level; // 3: Above s[2], 2: Between s[2]-s[1], 1: Between s[1]-s[0], 0: Below s[0]
    logic [1:0] prev_level;
    logic r_dfr;

    // Determine current level based on sensor pattern
    always @(*) begin
        if (s == 3'b111) current_level = 2'd3;
        else if (s == 3'b011) current_level = 2'd2;
        else if (s == 3'b001) current_level = 2'd1;
        else current_level = 2'd0;
    end

    // Determine nominal flow
    assign fr2 = (current_level == 2'd0);
    assign fr1 = (current_level == 2'd0 || current_level == 2'd1);
    assign fr0 = (current_level == 2'd0 || current_level == 2'd1 || current_level == 2'd2);

    // DFR logic: dfr = 1 if current_level < prev_level
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