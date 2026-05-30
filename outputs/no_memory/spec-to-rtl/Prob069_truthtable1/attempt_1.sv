module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

    logic f_logic;

    always @(*) begin
        case ({x3, x2, x1})
            3'b000: f_logic = 0;
            3'b001: f_logic = 0;
            3'b010: f_logic = 1;
            3'b011: f_logic = 1;
            3'b100: f_logic = 0;
            3'b101: f_logic = 1;
            3'b110: f_logic = 0;
            3'b111: f_logic = 1;
            default: f_logic = 0;
        endcase
    end

    assign f = f_logic;

endmodule