
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    localparam STATE_A = 2'b01;
    localparam STATE_B = 2'b10;

    logic [1:0] state, next_state;
    logic z_comb;

    assign z = z_comb;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        z_comb = 0;
        case (state)
            STATE_A: begin
                if (x == 0) begin
                    next_state = STATE_A;
                    z_comb = 0;
                end else begin
                    next_state = STATE_B;
                    z_comb = 1;
                end
            end
            STATE_B: begin
                next_state = STATE_B;
                if (x == 0) begin
                    z_comb = 1;
                end else begin
                    z_comb = 0;
                end
            end
            default: begin
                next_state = STATE_A;
                z_comb = 0;
            end
        endcase
    end

endmodule
