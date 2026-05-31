module TopModule (
    input [3:0] x,
    output f
);
    // Inputs: x[3], x[2], x[1], x[0]
    // K-map:
    // Rows: x[2]x[3]
    // Cols: x[0]x[1]
    
    // Map entries:
    // Row 00 (x2=0, x3=0):
    //   x0x1=00 -> x=0000 -> 1
    //   x0x1=01 -> x=0100 -> 0 (Note: x[0]=0, x[1]=1 -> x[3]=0, x[2]=0, x[1]=1, x[0]=0 => 0010)
    // Actually, look closely:
    // x[2]x[3]  00(00) 01(01) 11(11) 10(10)  (x0x1)
    // 00(00)  | 1 | 0 | 0 | 1 |
    // 01(01)  | 0 | 0 | 0 | 0 |
    // 11(11)  | 1 | 1 | 1 | 0 |
    // 10(10)  | 1 | 1 | 0 | 1 |

    // Let's list the combinations (x3, x2, x1, x0) where f=1:
    // Row 0 (x2=0, x3=0): 
    //   x0=0, x1=0 => x=0000 -> f=1
    //   x0=1, x1=0 => x=0001 -> f=1 (K-map col 10 is x0=1, x1=0)
    // Row 1 (x2=0, x3=1): none -> f=0
    // Row 2 (x2=1, x3=1):
    //   x0=0, x1=0 => x=1100 -> f=1
    //   x0=0, x1=1 => x=1110 -> f=1 (Col 01 is x0=0, x1=1)
    //   x0=1, x1=1 => x=1111 -> f=1 (Col 11 is x0=1, x1=1)
    // Row 3 (x2=1, x3=0):
    //   x0=0, x1=0 => x=1000 -> f=1
    //   x0=0, x1=1 => x=1010 -> f=1 (Col 01)
    //   x0=1, x1=0 => x=1001 -> f=1 (Col 10)

    logic f_val;
    always @(*) begin
        case (x)
            4'b0000: f_val = 1;
            4'b0010: f_val = 1;
            4'b1100: f_val = 1;
            4'b1110: f_val = 1;
            4'b1111: f_val = 1;
            4'b1000: f_val = 1;
            4'b1010: f_val = 1;
            4'b1001: f_val = 1;
            default: f_val = 0;
        endcase
    end
    assign f = f_val;
endmodule
