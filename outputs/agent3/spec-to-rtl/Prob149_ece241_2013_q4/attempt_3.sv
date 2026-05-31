module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // 水位編碼：s=000->0, s=001->1, s=011->2, s=111->3
    logic [1:0] curr, prev;

    always @(*) begin
        case (s)
            3'b000: curr = 2'd0;
            3'b001: curr = 2'd1;
            3'b011: curr = 2'd2;
            3'b111: curr = 2'd3;
            default: curr = 2'd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            prev <= 2'd0;
        end else begin
            prev <= curr;
        end
    end

    // 輸出邏輯
    // reset 時輸出應與 level 0 一樣，即 fr2, fr1, fr0, dfr 全部為 1
    always @(*) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} = 4'b1111;
        end else begin
            case (curr)
                2'd0: {fr2, fr1, fr0, dfr} = 4'b1111;
                2'd1: {fr2, fr1, fr0, dfr} = {1'b0, 1'b1, 1'b1, (prev > curr)};
                2'd2: {fr2, fr1, fr0, dfr} = {1'b0, 1'b0, 1'b1, (prev > curr)};
                2'd3: {fr2, fr1, fr0, dfr} = 4'b0000;
                default: {fr2, fr1, fr0, dfr} = 4'b0000;
            endcase
        end
    end

endmodule
