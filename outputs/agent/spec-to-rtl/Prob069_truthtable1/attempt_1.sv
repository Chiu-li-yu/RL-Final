module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    logic f_int;
    always @(*) begin
        case ({x3, x2, x1})
            3'b000: f_int = 0;
            3'b001: f_int = 0;
            3'b010: f_int = 1;
            3'b011: f_int = 1;
            3'b100: f_int = 0;
            3'b101: f_int = 1;
            3'b110: f_int = 0;
            3'b111: f_int = 1;
            default: f_int = 0;
        endcase
    end
    assign f = f_int;
endmodule
