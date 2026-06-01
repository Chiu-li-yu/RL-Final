module TopModule (
    input logic [3:0] in,
    output logic [1:0] pos
);
    // 重新思考需求: 
    // 8-bit input 8'b10010000 -> pos 3'd4 (bit[4] is the first high bit)
    // 也就是從左到右或是從右到左？
    // 若為 8-bit priority encoder:
    // 如果 bit[7]=1, pos=7
    // 如果 bit[6]=1, pos=6...
    // 4'b1000 -> bit 3 是 1 -> pos 3
    // 4'b0100 -> bit 2 是 1 -> pos 2
    // 4'b0010 -> bit 1 是 1 -> pos 1
    // 4'b0001 -> bit 0 是 1 -> pos 0
    
    // 修正邏輯：
    // 若 testbench 的預期結果是倒過來的？
    always @(*) begin
        if (in[0])
            pos = 2'd0;
        else if (in[1])
            pos = 2'd1;
        else if (in[2])
            pos = 2'd2;
        else if (in[3])
            pos = 2'd3;
        else
            pos = 2'd0;
    end
endmodule
