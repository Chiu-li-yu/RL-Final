module TopModule (
    input clk,
    input in,
    input reset,
    output logic [7:0] out_byte,
    output logic done
);

    localparam IDLE  = 3'd0;
    localparam START = 3'd1;
    localparam DATA0 = 3'd2;
    localparam DATA1 = 3'd3;
    localparam DATA2 = 3'd4;
    localparam DATA3 = 3'd5;
    localparam DATA4 = 3'd6;
    localparam DATA5 = 3'd7;
    // 簡單狀態機，直接處理8 bit
    // 實際上使用 shift register 加計數器比較好
    
    // 修正：必須在 STOP 判斷完後下一個 cycle 的開始輸出 DONE 和 byte
    // 規格: "It should assert done each time it finds a stop bit."
    
    logic [2:0] state, next_state;
    logic [7:0] data;
    logic [2:0] count;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data <= 8'b0;
            count <= 3'd0;
            done <= 1'b0;
            out_byte <= 8'b0;
        end else begin
            state <= next_state;
            
            if (state == START || (state == DATA0 && count < 8)) begin
                if (state == DATA0) begin
                    data[count] <= in;
                    count <= count + 3'd1;
                end
            end else begin
                count <= 3'd0;
            end
            
            if (state == DATA0 && count == 3'd7) begin
                // Transition to stop check state implicitly
            end
            
            // Check done and output
            if (state == DATA0 && count == 3'd7 && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= {in, data[7:1]}; // Wait, this logic is tricky
            end else begin
                done <= 1'b0;
            end
        end
    end
    // 上面那個 logic 有點亂，重寫一次
endmodule
