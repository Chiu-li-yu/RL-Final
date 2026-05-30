module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);
    logic [2:0] next_state;

    // Output logic and next state logic based on the table
    always @(*) begin
        case (y)
            3'b000: begin
                next_state = (x == 0) ? 3'b000 : 3'b001;
                // z = 0
            end
            3'b001: begin
                next_state = (x == 0) ? 3'b001 : 3'b100;
                // z = 0
            end
            3'b010: begin
                next_state = (x == 0) ? 3'b010 : 3'b001;
                // z = 0
            end
            3'b011: begin
                next_state = (x == 0) ? 3'b001 : 3'b010;
                // z = 1
            end
            3'b100: begin
                next_state = (x == 0) ? 3'b011 : 3'b100;
                // z = 1
            end
            default: begin
                next_state = 3'b000;
            end
        endcase
    end

    // Output z logic
    assign z = (y == 3'b011 || y == 3'b100) ? 1'b1 : 1'b0;

    // Y0 is Y[0] of the next state
    assign Y0 = next_state[0];

endmodule
