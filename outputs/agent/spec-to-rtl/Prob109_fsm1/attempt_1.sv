module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    parameter B = 1'b0;
    parameter A = 1'b1;

    logic state, next_state;

    // 非同步重置邏輯，進入狀態 B
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // 狀態轉移組合邏輯
    always @(*) begin
        case (state)
            B: begin
                if (in) next_state = B;
                else    next_state = A;
            end
            A: begin
                if (in) next_state = A;
                else    next_state = B;
            end
            default: next_state = B;
        endcase
    end

    // 輸出組合邏輯 (Moore machine)
    // B (1) --0--> A
    // B (1) --1--> B
    // A (0) --0--> B
    // A (0) --1--> A
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule
