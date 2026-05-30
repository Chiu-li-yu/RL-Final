module TopModule(
    input [3:0] x,
    output f
);
    // K-map layout:
    // Row = {x[2], x[3]}
    // Col = {x[0], x[1]}
    
    // x[2]x[3] x[0]x[1]  f
    // 00       00        1
    // 00       01        0
    // 00       11        0
    // 00       10        1
    // 01       00        0
    // 01       01        0
    // 01       11        0
    // 01       10        0
    // 11       00        1
    // 11       01        1
    // 11       11        1
    // 11       10        0
    // 10       00        1
    // 10       01        1
    // 10       11        0
    // 10       10        1

    logic f_logic;
    always @(*) begin
        case (x)
            4'b0000: f_logic = 1;
            4'b0001: f_logic = 0;
            4'b0011: f_logic = 0;
            4'b0010: f_logic = 1;
            4'b0100: f_logic = 0;
            4'b0101: f_logic = 0;
            4'b0111: f_logic = 0;
            4'b0110: f_logic = 0;
            4'b1100: f_logic = 1;
            4'b1101: f_logic = 1;
            4'b1111: f_logic = 1;
            4'b1110: f_logic = 0;
            4'b1000: f_logic = 1;
            4'b1001: f_logic = 1;
            4'b1011: f_logic = 0;
            4'b1010: f_logic = 1;
            default: f_logic = 0;
        endcase
    end
    assign f = f_logic;
endmodule