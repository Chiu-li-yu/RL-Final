module TopModule (
    input clk,
    input areset,
    input in,
    output out
);
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    logic current_state;
    logic next_state;

    // 非同步重置，狀態為 B
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= STATE_B;
        else
            current_state <= next_state;
    end

    // 狀態轉移邏輯
    always_comb begin
        case (current_state)
            STATE_A: begin
                if (in) next_state = STATE_A;
                else    next_state = STATE_B;
            end
            STATE_B: begin
                if (in) next_state = STATE_B;
                else    next_state = STATE_A;
            end
            default: next_state = STATE_B;
        endcase
    end

    // 輸出邏輯 (Moore Machine: 輸出僅取決於當前狀態)
    assign out = (current_state == STATE_B);

endmodule
