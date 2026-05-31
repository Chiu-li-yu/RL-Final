module TopModule (
    input c,
    input d,
    input a,
    input b,
    output logic [3:0] mux_in
);
    // 根據題目描述，TopModule 需要處理 a, b 作為 selector，
    // 但題目僅給定 c, d 作為輸入埠。
    // 然而，根據題目：「You must use a and b as the multiplexer selector inputs...」
    // 且「Consider a block diagram with inputs 'c' and 'd' going into a module called 'TopModule'」
    // 實際上在 4-to-1 Mux 的邏輯中，a 和 b 是作為選擇器，
    // 而 TopModule 的輸出 mux_in[3:0] 是依據 c, d 決定的。
    // 因此 a 和 b 應該作為 TopModule 的輸入，或者它們是外部連接的。
    // 題目提到：input c, input d，但又說 a, b 是 mux selector。
    // 重新閱讀：「You must use a and b as the multiplexer selector inputs, as shown on the 4-to-1 multiplexer below.」
    // 且 TopModule 的 interface 僅列出 c, d。
    // 這意味著 a, b 必須由外部傳入或作為模組輸入。
    // 根據題目：「Consider a block diagram with inputs 'c' and 'd' going into a module called 'TopModule'」。
    // 這裡我假設 TopModule 的輸入只有 c, d。
    // 但若要依據 K-map，每一行代表 a, b 的值。
    // 題目問的是 TopModule 產生的 mux_in[0..3]。
    // 根據 K-map，mux_in[0] 是 ab=00 時 c,d 的函數，mux_in[1] 是 ab=01 時...
    // 所以其實是將 a, b 排除在 TopModule 內，直接輸出 mux_in[0..3]。
    // 修正：TopModule 確實只要輸入 c, d。

    always @(*) begin
        mux_in[0] = c | d;          // ab=00
        mux_in[1] = 1'b0;           // ab=01
        mux_in[2] = c & d;          // ab=11
        mux_in[3] = ~(c ^ d);       // ab=10
    end
endmodule
