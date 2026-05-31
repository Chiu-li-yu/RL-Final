module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    logic [2:0] next_state;
    logic [2:0] state;

    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always @(*) begin
        case (y)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
    end

    assign Y0 = next_state[0];
    assign z = (y == 3'b011 || y == 3'b100) ? 1'b1 : 1'b0;

endmodule
