module TopModule(
    input  logic [2:0] y,
    input  logic       w,
    output logic       Y1
);

    // 根據狀態定義
    // A: 000, B: 001, C: 010, D: 011, E: 100, F: 101
    
    // 輸出 Y1 定義為 y[1]
    assign Y1 = y[1];

endmodule