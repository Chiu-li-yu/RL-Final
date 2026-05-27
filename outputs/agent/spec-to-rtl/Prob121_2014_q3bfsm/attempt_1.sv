module TopModule (
    input logic clk,
    input logic reset,
    input logic x,
    output logic z
);

    typedef enum logic [2:0] {
        S000 = 3'b000,
        S001 = 3'b001,
        S010 = 3'b010,
        S011 = 3'b011,
        S100 = 3'b100
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S000;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        case (state)
            S000: next_state = (x) ? S001 : S000;
            S001: next_state = (x) ? S100 : S001;
            S010: next_state = (x) ? S001 : S010;
            S011: next_state = (x) ? S010 : S001;
            S100: next_state = (x) ? S100 : S011;
            default: next_state = S000;
        endcase
    end

    always_comb begin
        case (state)
            S000: z = 1'b0;
            S001: z = 1'b0;
            S010: z = 1'b0;
            S011: z = 1'b1;
            S100: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule
