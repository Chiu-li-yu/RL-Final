module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output logic done
);
    // 狀態機設計：
    // 收到 valid byte (in[3]=1) 後進入 Byte 1 狀態。
    // 隨後自動接收 Byte 2、Byte 3。
    // 在收到 Byte 3 的下一個 cycle 輸出 done。
    
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        B2   = 2'd1,
        B3   = 2'd2,
        DONE = 2'd3
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        done = 1'b0;

        case (state)
            IDLE: begin
                if (in[3]) next_state = B2;
                else next_state = IDLE;
            end
            B2: begin
                next_state = B3;
            end
            B3: begin
                next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                if (in[3]) next_state = B2;
                else next_state = IDLE;
            end
        endcase
    end
endmodule
