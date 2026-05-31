module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output logic fr2,
    output logic fr1,
    output logic fr0,
    output logic dfr
);

    // 水位編碼：s=000(0), s=001(1), s=011(2), s=111(3)
    logic [1:0] curr;
    logic [1:0] prev;

    always @(*) begin
        case (s)
            3'b000: curr = 2'd0;
            3'b001: curr = 2'd1;
            3'b011: curr = 2'd2;
            3'b111: curr = 2'd3;
            default: curr = 2'd0;
        endcase
    end

    // 狀態轉移（同步 reset）
    always @(posedge clk) begin
        if (reset) begin
            prev <= 2'd0;
        end else begin
            prev <= curr;
        end
    end

    // 輸出邏輯 (Mealy 輸出，與 reset 同步)
    always @(*) begin
        if (reset) begin
            fr2 = 1'b1; fr1 = 1'b1; fr0 = 1'b1; dfr = 1'b1;
        end else begin
            case (curr)
                2'd0: begin fr2 = 1'b1; fr1 = 1'b1; fr0 = 1'b1; dfr = 1'b1; end
                2'd1: begin fr2 = 1'b0; fr1 = 1'b1; fr0 = 1'b1; dfr = (prev > curr); end
                2'd2: begin fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b1; dfr = (prev > curr); end
                2'd3: begin fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b0; dfr = 1'b0; end
                default: begin fr2 = 1'b0; fr1 = 1'b0; fr0 = 1'b0; dfr = 1'b0; end
            endcase
        end
    end

endmodule
