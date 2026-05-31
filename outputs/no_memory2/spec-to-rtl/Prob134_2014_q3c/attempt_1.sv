module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    logic [2:0] next_state;
    logic output_z;

    always @(*) begin
        case (y)
            3'b000: begin
                next_state = (x == 1'b0) ? 3'b000 : 3'b001;
                output_z = 1'b0;
            end
            3'b001: begin
                next_state = (x == 1'b0) ? 3'b001 : 3'b100;
                output_z = 1'b0;
            end
            3'b010: begin
                next_state = (x == 1'b0) ? 3'b010 : 3'b001;
                output_z = 1'b0;
            end
            3'b011: begin
                next_state = (x == 1'b0) ? 3'b001 : 3'b010;
                output_z = 1'b1;
            end
            3'b100: begin
                next_state = (x == 1'b0) ? 3'b011 : 3'b100;
                output_z = 1'b1;
            end
            default: begin
                next_state = 3'b000;
                output_z = 1'b0;
            end
        endcase
    end

    assign Y0 = next_state[0];
    assign z = output_z;

endmodule
