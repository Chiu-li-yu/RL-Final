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

    // Decode sensors to current_level
    // s[2:0] mapping:
    // 111 (s[2],s[1],s[0] asserted) -> Level 3
    // 011 (s[1],s[0] asserted) -> Level 2
    // 001 (s[0] asserted) -> Level 1
    // 000 (none asserted) -> Level 0
    always @(*) begin
        case (s)
            3'b111: current_level = 2'd3;
            3'b011: current_level = 2'd2;
            3'b001: current_level = 2'd1;
            3'b000: current_level = 2'd0;
            default: current_level = 2'd0;
        endcase
    end

    // Sequential update of prev_level
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0;
        end else begin
            prev_level <= current_level;
        end
    end

    // Nominal outputs fr0, fr1, fr2
    assign fr0 = (current_level == 2'd0) || (current_level == 2'd1) || (current_level == 2'd2);
    assign fr1 = (current_level == 2'd0) || (current_level == 2'd1);
    assign fr2 = (current_level == 2'd0);

    // Supplemental flow valve dfr
    // Logic:
    // Below s[0] (Level 0): dfr=1
    // Above s[2] (Level 3): dfr=0
    // Others: (prev_level > current_level) ? 1 : 0
    assign dfr = (current_level == 2'd0) ? 1'b1 :
                 (current_level == 2'd3) ? 1'b0 :
                 (prev_level > current_level) ? 1'b1 : 1'b0;

endmodule