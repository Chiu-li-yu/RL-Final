module TopModule (
    input [3:0] x,
    output f
);
    // K-map table:
    // x[2]x[3] | x[0]x[1]
    //          | 00 | 01 | 11 | 10
    // ----------------------------
    // 00       | 1  | 0  | 0  | 1
    // 01       | 0  | 0  | 0  | 0
    // 11       | 1  | 1  | 1  | 0
    // 10       | 1  | 1  | 0  | 1

    // Map minterms (where f=1):
    // (x[2],x[3],x[0],x[1])
    // 0000 -> 0
    // 0010 -> 0
    // 0011 -> 0
    // 0001 -> 1
    // 0100 -> 0
    // 0101 -> 0
    // 0111 -> 0
    // 0110 -> 0
    // 1100 -> 3
    // 1101 -> 3
    // 1111 -> 3
    // 1110 -> 2
    // 1000 -> 2
    // 1001 -> 2
    // 1011 -> 2
    // 1010 -> 2

    // Let's list the inputs as (x3, x2, x1, x0) based on indices:
    // Row: x[2]x[3], Col: x[0]x[1]
    // 0000: f=1
    // 0010: f=0
    // 0011: f=0
    // 0001: f=1
    // ...
    // Wait, let's map it clearly:
    // Index: x2 x3 | x0 x1
    // Row 00 (x2=0, x3=0):
    // Col 00 (x0=0, x1=0): f=1. Input=0000
    // Col 01 (x0=0, x1=1): f=0. Input=0010
    // Col 11 (x0=1, x1=1): f=0. Input=0011
    // Col 10 (x0=1, x1=0): f=1. Input=0001
    // Row 01 (x2=0, x3=1):
    // All 0.
    // Row 11 (x2=1, x3=1):
    // Col 00 (x0=0, x1=0): f=1. Input=1100
    // Col 01 (x0=0, x1=1): f=1. Input=1110
    // Col 11 (x0=1, x1=1): f=1. Input=1111
    // Col 10 (x0=1, x1=0): f=0. Input=1101
    // Row 10 (x2=1, x3=0):
    // Col 00 (x0=0, x1=0): f=1. Input=1000
    // Col 01 (x0=0, x1=1): f=1. Input=1010
    // Col 11 (x0=1, x1=1): f=0. Input=1011
    // Col 10 (x0=1, x1=0): f=1. Input=1001

    // Re-verify inputs:
    // Input is x[3:0].
    // Let's identify the bits:
    // f = 1 when (x2,x3,x0,x1) in {0000, 0001, 1100, 1110, 1111, 1000, 1010, 1001}

    always @(*) begin
        case (x)
            4'b0000: f = 1'b1;
            4'b0001: f = 1'b1;
            4'b1100: f = 1'b1;
            4'b1110: f = 1'b1;
            4'b1111: f = 1'b1;
            4'b1000: f = 1'b1;
            4'b1010: f = 1'b1;
            4'b1001: f = 1'b1;
            default: f = 1'b0;
        endcase
    end
endmodule
