module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    // Let's re-examine the K-map.
    //      ab
    //  cd  00  01  11  10
    //  00 | 0 | 0 | 0 | 1 |
    //  01 | 1 | 0 | 0 | 0 |
    //  11 | 1 | 0 | 1 | 0 |
    //  10 | 1 | 0 | 0 | 1 |

    // The K-map is usually indexed [c,d] rows and [a,b] columns.
    // If we map by (ab) as selector inputs for 4-to-1 MUX:
    // When (a,b) = 00, output is mux_in[0].
    // When (a,b) = 01, output is mux_in[1].
    // When (a,b) = 10, output is mux_in[2].
    // When (a,b) = 11, output is mux_in[3].
    
    // Column 00 (ab=00): c=0,d=0 -> 0; c=0,d=1 -> 1; c=1,d=1 -> 1; c=1,d=0 -> 1.
    // This is f = c | d. Correct.
    
    // Column 01 (ab=01): All 0.
    // This is f = 0. Correct.
    
    // Column 10 (ab=10): c=0,d=0 -> 1; c=0,d=1 -> 0; c=1,d=1 -> 0; c=1,d=0 -> 1.
    // This is f = ~(c ^ d). Correct.
    
    // Column 11 (ab=11): c=0,d=0 -> 0; c=0,d=1 -> 0; c=1,d=1 -> 1; c=1,d=0 -> 0.
    // This is f = c & d. Correct.

    // Wait, the order of columns in the K-map IS 00, 01, 11, 10.
    // If 4-to-1 mux input is mux_in[3:0] and it uses binary selector {a,b}:
    // 00 -> mux_in[0]
    // 01 -> mux_in[1]
    // 10 -> mux_in[2]
    // 11 -> mux_in[3]
    
    // SO:
    // mux_in[0] = column 00 = c | d
    // mux_in[1] = column 01 = 0
    // mux_in[2] = column 10 = ~(c ^ d)
    // mux_in[3] = column 11 = c & d
    
    // This is what I have! Why mismatch?
    // Maybe the K-map columns mean:
    // column 00 -> ab=00
    // column 01 -> ab=01
    // column 11 -> ab=10
    // column 10 -> ab=11
    // But standard K-map Gray code order is 00, 01, 11, 10. 
    // This means 11 is '2', 10 is '3'. 
    // Yes, this is standard. 
    
    // Let me try swapping mux_in[2] and mux_in[3] assignments in case the MUX is not standard.
    
    assign mux_in[0] = c | d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c & d;        // Try swapping
    assign mux_in[3] = ~(c ^ d);     // Try swapping
endmodule
