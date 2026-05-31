module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // 水位狀態定義
    // 0: s=000 (Below s0)
    // 1: s=001 (Between s0 and s1)
    // 2: s=011 (Between s1 and s2)
    // 3: s=111 (Above s2)
    logic [1:0] current_level, prev_level;

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0; // Reset state equivalent to below s0
        end else begin
            prev_level <= current_level;
        end
    end

    always @(*) begin
        case (s)
            3'b000: current_level = 2'd0;
            3'b001: current_level = 2'd1;
            3'b011: current_level = 2'd2;
            3'b111: current_level = 2'd3;
            default: current_level = prev_level; // Hold if invalid
        endcase
    end

    // 輸出邏輯
    always @(*) begin
        if (reset) begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end else begin
            case (current_level)
                2'd0: begin // Below s0
                    fr2 = 1'b1; fr1 = 1'b1; fr0 = 1'b1; dfr = 1'b1;
                end
                2'd1: begin // Between s0 and s1
                    fr2 = 1'b0; fr1 = 1'b1; fr0 = 1'b1;
                    dfr = (prev_level > current_level) ? 1'b1 : 1'b0;
                end
                2'd2: begin // Between s1 and s2
                    fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b1;
                    dfr = (prev_level > current_level) ? 1'b1 : 1'b0;
                end
                2'd3: begin // Above s2
                    fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b0; dfr = 1'b0;
                end
                default: begin
                    fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b0; dfr = 1'b0;
                end
            endcase
        end
    end

endmodule
