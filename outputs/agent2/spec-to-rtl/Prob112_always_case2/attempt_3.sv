module TopModule (
    input logic [3:0] in,
    output logic [1:0] pos
);
    // 規格: 
    // 4'b1000 -> 3
    // 4'b0100 -> 2
    // 4'b0010 -> 1
    // 4'b0001 -> 0
    // 4'b0000 -> 0
    always @(*) begin
        case (1'b1)
            in[3]: pos = 2'd3;
            in[2]: pos = 2'd2;
            in[1]: pos = 2'd1;
            in[0]: pos = 2'd0;
            default: pos = 2'd0;
        endcase
    end
endmodule
