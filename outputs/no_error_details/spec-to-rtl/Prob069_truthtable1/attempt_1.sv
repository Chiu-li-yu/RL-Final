module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

    logic f_val;

    always @(*) begin
        case ({x3, x2, x1})
            3'b000: f_val = 1'b0;
            3'b001: f_val = 1'b0;
            3'b010: f_val = 1'b1;
            3'b011: f_val = 1'b1;
            3'b100: f_val = 1'b0;
            3'b101: f_val = 1'b1;
            3'b110: f_val = 1'b0;
            3'b111: f_val = 1'b1;
            default: f_val = 1'b0;
        endcase
    end

    assign f = f_val;

endmodule
