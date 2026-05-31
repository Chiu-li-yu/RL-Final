module TopModule (
    input logic [3:0] x,
    output logic f
);

    // x[0] is x[3] in K-map (MSB)
    // x[1] is x[4] in K-map
    // x[2] is x[1] in K-map
    // x[3] is x[2] in K-map

    // Map:
    // Rows (x[3]x[4]): 00, 01, 11, 10
    // Cols (x[1]x[2]): 00, 01, 11, 10

    // K-map values:
    // x[3]x[4] \ x[1]x[2] | 00 | 01 | 11 | 10
    // ----------------------------------------
    // 00 (0,0)            | d  | 0  | d  | d
    // 01 (0,1)            | 0  | d  | 1  | 0
    // 11 (1,1)            | 1  | 1  | d  | d
    // 10 (1,0)            | 1  | 1  | 0  | d

    // Let's assign don't cares (d) to optimize f:
    // f(0000)=1, f(0010)=1, f(0011)=1
    // f(0101)=1, f(0111)=1
    // f(1100)=1, f(1101)=1, f(1110)=1, f(1111)=1
    // f(1000)=1, f(1001)=1, f(1010)=1

    // Mapping variables:
    // A = x[3] (row MSB)
    // B = x[2] (row LSB)
    // C = x[1] (col MSB)
    // D = x[0] (col LSB)

    // Using Karnaugh Map Solver/Optimization:
    // f = A|(!B&!C)  <-- Simplified
    
    always @(*) begin
        case (x)
            4'b0000: f = 1;
            4'b0001: f = 0;
            4'b0010: f = 1;
            4'b0011: f = 1;
            4'b0100: f = 0;
            4'b0101: f = 1;
            4'b0110: f = 1; // d -> 1
            4'b0111: f = 1;
            4'b1100: f = 1;
            4'b1101: f = 1;
            4'b1110: f = 1; // d -> 1
            4'b1111: f = 1; // d -> 1
            4'b1000: f = 1;
            4'b1001: f = 1;
            4'b1010: f = 0;
            4'b1011: f = 1; // d -> 1
            default: f = 0;
        endcase
    end
endmodule
