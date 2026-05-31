module TopModule (
    input [3:0] x,
    output logic f
);
    always @(*) begin
        case (x)
            4'b0000, 4'b0001, 4'b1100, 4'b1110, 4'b1111, 4'b1000, 4'b1010, 4'b1001: f = 1'b1;
            default: f = 1'b0;
        endcase
    end
endmodule
