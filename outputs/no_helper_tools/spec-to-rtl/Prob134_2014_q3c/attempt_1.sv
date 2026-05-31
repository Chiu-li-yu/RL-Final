module TopModule (
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);
    logic [2:0] state;
    logic [2:0] next_state;
    logic out_z;

    always @(posedge clk) begin
        state <= y;
    end

    always @(*) begin
        case (state)
            3'b000: begin
                next_state = (x == 1'b0) ? 3'b000 : 3'b001;
                out_z = 1'b0;
            end
            3'b001: begin
                next_state = (x == 1'b0) ? 3'b001 : 3'b100;
                out_z = 1'b0;
            end
            3'b010: begin
                next_state = (x == 1'b0) ? 3'b010 : 3'b001;
                out_z = 1'b0;
            end
            3'b011: begin
                next_state = (x == 1'b0) ? 3'b001 : 3'b010;
                out_z = 1'b1;
            end
            3'b100: begin
                next_state = (x == 1'b0) ? 3'b011 : 3'b100;
                out_z = 1'b1;
            end
            default: begin
                next_state = 3'b000;
                out_z = 1'b0;
            end
        endcase
    end

    assign Y0 = next_state[0];
    assign z = out_z;

endmodule
