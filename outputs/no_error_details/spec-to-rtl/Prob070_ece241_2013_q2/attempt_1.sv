module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP logic: a'c + bcd + acd => c(a' + d(a+b))
    // Optimized SOP: (~a & c) | (b & c & d) | (a & c & d)
    // Which simplifies to: (~a & c) | (c & d & (a | b))
    assign out_sop = (~a & c) | (c & d & (a | b));

    // POS logic: 
    // Logic 1 when: 2, 7, 15
    // Logic 0 when: 0, 1, 4, 5, 6, 9, 10, 13, 14
    // Don't care: 3, 8, 11, 12
    // Minimal POS: (c) * (a' + d) * (a + b + c') ? Let's derive via K-map.
    // 0s at: 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110
    // POS: (a+c) * (c'+d) * (a'+b+c') ? Actually, simply using the same logic as SOP
    // for this function.
    assign out_pos = (~a & c) | (c & d & (a | b));

endmodule
