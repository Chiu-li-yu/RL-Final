module TopModule (
    input logic [3:0] in,
    output logic [1:0] pos
);
    // 檢查每個 bit 是否為 1，並根據優先權給予輸出
    always @(*) begin
        if (in[3])
            pos = 2'd3;
        else if (in[2])
            pos = 2'd2;
        else if (in[1])
            pos = 2'd1;
        else
            pos = 2'd0;
    end
endmodule
