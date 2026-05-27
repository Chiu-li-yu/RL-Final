module TopModule (
    input logic clk,
    input logic reset,
    input logic x,
    output logic z
);

    logic [2:0] state;
    logic [2:0] next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            3'b000: next_state = (x) ? 3'b001 : 3'b000;
            3'b001: next_state = (x) ? 3'b100 : 3'b001;
            3'b010: next_state = (x) ? 3'b001 : 3'b010;
            3'b011: next_state = (x) ? 3'b010 : 3'b001;
            3'b100: next_state = (x) ? 3'b100 : 3'b011;
            default: next_state = 3'b000;
        endcase
    end

    always_comb begin
        case (state)
            3'b000: z = 1'b0;
            3'b001: z = 1'b0;
            3'b010: z = 1'b0;
            3'b011: z = 1'b1;
            3'b100: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule
