module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // 當前與上一時刻的水位狀態
    // s=000: level 0
    // s=001: level 1
    // s=011: level 2
    // s=111: level 3
    logic [1:0] curr, prev;

    always @(*) begin
        case (s)
            3'b000: curr = 2'd0;
            3'b001: curr = 2'd1;
            3'b011: curr = 2'd2;
            3'b111: curr = 2'd3;
            default: curr = 2'd0; // Treat undefined as 0 for safety
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            prev <= 2'd0;
        end else begin
            prev <= curr;
        end
    end

    // 輸出邏輯 (Moore machine based on curr and prev)
    always @(*) begin
        // 預設值
        fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b0; dfr = 1'b0;

        case (curr)
            2'd0: begin
                fr2 = 1'b1; fr1 = 1'b1; fr0 = 1'b1; dfr = 1'b1;
            end
            2'd1: begin
                fr2 = 1'b0; fr1 = 1'b1; fr0 = 1'b1;
                dfr = (prev > curr) ? 1'b1 : 1'b0;
            end
            2'd2: begin
                fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b1;
                dfr = (prev > curr) ? 1'b1 : 1'b0;
            end
            2'd3: begin
                fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b0; dfr = 1'b0;
            end
        endcase
    end

endmodule
