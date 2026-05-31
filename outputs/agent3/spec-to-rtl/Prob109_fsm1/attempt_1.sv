module TopModule(
    input clk,
    input areset,
    input in,
    output out
);
    localparam A = 1'b0;
    localparam B = 1'b1;

    logic current_state;
    logic next_state;

    // 非同步重置，回到狀態 B (1)
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= B;
        else
            current_state <= next_state;
    end

    // 狀態轉移邏輯
    always @(*) begin
        case (current_state)
            A: next_state = (in == 1'b0) ? B : A;
            B: next_state = (in == 1'b0) ? A : B;
            default: next_state = B;
        endcase
    end

    // 輸出邏輯 (Moore machine: 輸出只與狀態有關)
    assign out = (current_state == B) ? 1'b1 : 1'b0;

endmodule