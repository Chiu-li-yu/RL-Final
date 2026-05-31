module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);
    logic [2:0] next_state;
    logic z_out;

    always @(*) begin
        case (y)
            3'b000: next_state = x ? 3'b001 : 3'b000;
            3'b001: next_state = x ? 3'b100 : 3'b001;
            3'b010: next_state = x ? 3'b001 : 3'b010;
            3'b011: next_state = x ? 3'b010 : 3'b001;
            3'b100: next_state = x ? 3'b100 : 3'b011;
            default: next_state = 3'b000;
        endcase
    end

    always @(*) begin
        case (y)
            3'b011: z_out = 1'b1;
            3'b100: z_out = 1'b1;
            default: z_out = 1'b0;
        endcase
    end

    assign Y0 = next_state[0];
    assign z = z_out;
endmodule
