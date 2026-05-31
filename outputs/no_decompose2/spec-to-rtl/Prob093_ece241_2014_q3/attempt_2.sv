module TopModule (
    input c,
    input d,
    output logic [3:0] mux_in
);
    // K-map (ab as selector for 4-to-1 mux)
    // The columns are defined as ab = 00, 01, 11, 10
    // Rows are cd = 00, 01, 11, 10

    // ab = 00 (column 0)
    // cd=00(0) -> 0
    // cd=01(1) -> 1
    // cd=11(3) -> 1
    // cd=10(2) -> 1
    // This is C | D. Correct.

    // ab = 01 (column 1)
    // cd=00(0) -> 0
    // cd=01(1) -> 0
    // cd=11(3) -> 0
    // cd=10(2) -> 0
    // Always 0. Correct.

    // ab = 11 (column 2)
    // cd=00(0) -> 0
    // cd=01(1) -> 0
    // cd=11(3) -> 1
    // cd=10(2) -> 0
    // This is C & D. Correct.

    // ab = 10 (column 3)
    // cd=00(0) -> 1
    // cd=01(1) -> 0
    // cd=11(3) -> 0
    // cd=10(2) -> 1
    // This is ~(C ^ D) (XNOR). Correct.

    // The issue might be the index mapping of the mux_in port.
    // The prompt says:
    // "ab = 00 is connected to mux_in[0], ab=01 is connected to mux_in[1], and so in."
    // This means:
    // mux_in[0] for ab=00
    // mux_in[1] for ab=01
    // mux_in[2] for ab=11
    // mux_in[3] for ab=10
    // My mapping is correct.

    // Wait, let's re-verify the K-map values and indexes.
    // cd rows: 00, 01, 11, 10 (This is Gray code ordering usually)
    // The table shows:
    //    ab
    // cd 00 01 11 10
    // 00 0  0  0  1
    // 01 1  0  0  0
    // 11 1  0  1  0
    // 10 1  0  0  1

    // Re-check ab=11 (column 2)
    // row 00: 0
    // row 01: 0
    // row 11: 1
    // row 10: 0
    // Correct (C&D).

    // Re-check ab=10 (column 3)
    // row 00: 1
    // row 01: 0
    // row 11: 0
    // row 10: 1
    // If c=0,d=0 -> 1
    // If c=0,d=1 -> 0
    // If c=1,d=1 -> 0
    // If c=1,d=0 -> 1
    // This is ~c & ~d | c & ~d? No.
    // It is ~(c^d).

    // The order of columns in the mux is usually determined by the selector bits (b,a) or (a,b).
    // The prompt says "using a and b as the multiplexer selector inputs, as shown on the 4-to-1 multiplexer below."
    // And "ab = 00 is connected to mux_in[0], ab=01 is connected to mux_in[1]..."
    // Maybe the K-map columns are actually not 00, 01, 11, 10 for the mux_in bits order?
    // Oh, the K-map columns are 00, 01, 11, 10.
    // Mux input 0 is for select 00.
    // Mux input 1 is for select 01.
    // Mux input 2 is for select 10.
    // Mux input 3 is for select 11.
    // BUT the prompt says "ab=11 is connected to mux_in[2]" and "ab=10 is connected to mux_in[3]".
    // This is the common "trick" where the 4-to-1 mux selector 10 is usually for input 2, and 11 is for input 3.
    // Let me swap mux_in[2] and mux_in[3].

    always @(*) begin
        mux_in[0] = c | d;          // ab=00
        mux_in[1] = 1'b0;           // ab=01
        mux_in[2] = ~(c ^ d);       // ab=10 (was 3)
        mux_in[3] = (c & d);        // ab=11 (was 2)
    end
endmodule
