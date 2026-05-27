module TopModule (
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic out
);

    // Karnaugh Map analysis:
    //    cd \ ab | 00 | 01 | 11 | 10
    //    ---------------------------
    //    00      |  1 |  1 |  0 |  1 |
    //    01      |  1 |  0 |  0 |  1 |
    //    11      |  0 |  1 |  1 |  1 |
    //    10      |  1 |  1 |  0 |  0 |

    // Map to boolean expression:
    // Using SOP (Sum of Products)
    // Terms (where out=1):
    // 0000: !a!b!c!d
    // 0001: !a!b!cd
    // 0010: !a!bc!d
    // 0100: !ab!c!d
    // 0111: !abc d
    // 1000: a!b!c!d
    // 1001: a!b!cd
    // 1101: ab!c d
    // 1111: abcd
    // 1110: abc!d
    // 1011: a!bc d

    // Simplified Boolean expression using logic minimization:
    // out = (!a & !c & !d) | (!b & !c & !d) | (!a & b & c & d) | (a & !b & c & d) | (a & b & !c & d) | (a & b & c & d) | (!b & c & !d) | (a & c & !d)
    
    // Alternative representation based on K-Map grouping:
    // out = (~a & ~c & ~d) | (~b & ~c & ~d) | (~b & c & ~d) | (~a & b & c & d) | (a & b & !c & d) | (a & !b & c & d) | (a & b & c & d) | (a & c & !d)
    
    always @(*) begin
        out = (~a & ~c & ~d) | 
              (~b & ~c & ~d) | 
              (~a & b & c & d) | 
              (a & !b & c & d) | 
              (a & b & !c & d) | 
              (a & b & c & d) | 
              (~b & c & !d) | 
              (a & c & !d);
    end

endmodule
