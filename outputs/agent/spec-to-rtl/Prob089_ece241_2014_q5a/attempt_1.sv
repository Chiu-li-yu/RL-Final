
module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    localparam S_ZERO = 2'd0,
               S_HIGH = 2'd1,
               S_LOW  = 2'd2;

    logic [1:0] state, next_state;
    logic z_comb;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_ZERO;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S_ZERO: begin
                if (x == 1'b0) next_state = S_ZERO;
                else           next_state = S_HIGH;
            end
            S_HIGH: begin
                if (x == 1'b0) next_state = S_HIGH;
                else           next_state = S_LOW;
            end
            S_LOW: begin
                if (x == 1'b0) next_state = S_HIGH;
                else           next_state = S_LOW;
            end
            default: next_state = S_ZERO;
        endcase
    end

    always @(*) begin
        case (state)
            S_ZERO: z_comb = 1'b0;
            S_HIGH: z_comb = 1'b1;
            S_LOW:  z_comb = 1'b0;
            default: z_comb = 1'b0;
        endcase
    end

    assign z = z_comb;

endmodule
