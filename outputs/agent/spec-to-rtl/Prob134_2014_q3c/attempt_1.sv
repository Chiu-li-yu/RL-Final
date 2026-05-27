module TopModule (
    input logic clk,
    input logic x,
    input logic [2:0] y,
    output logic Y0,
    output logic z
);

    logic [2:0] next_y;
    logic [2:0] current_y;

    // Sequential logic for state register
    always_ff @(posedge clk) begin
        current_y <= next_y;
    end

    // Next state and output logic
    always @(*) begin
        case (y)
            3'b000: begin
                next_y = (x == 1'b0) ? 3'b000 : 3'b001;
                z = 1'b0;
            end
            3'b001: begin
                next_y = (x == 1'b0) ? 3'b001 : 3'b100;
                z = 1'b0;
            end
            3'b010: begin
                next_y = (x == 1'b0) ? 3'b010 : 3'b001;
                z = 1'b0;
            end
            3'b011: begin
                next_y = (x == 1'b0) ? 3'b001 : 3'b010;
                z = 1'b1;
            end
            3'b100: begin
                next_y = (x == 1'b0) ? 3'b011 : 3'b100;
                z = 1'b1;
            end
            default: begin
                next_y = 3'b000;
                z = 1'b0;
            end
        endcase
    end

    assign Y0 = next_y[0];

endmodule
