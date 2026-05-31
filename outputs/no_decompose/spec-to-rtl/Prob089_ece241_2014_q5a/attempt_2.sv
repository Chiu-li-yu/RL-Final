module TopModule(
    input clk,
    input areset,
    input x,
    output z
);
    // State machine for 2's complementer (Moore machine)
    // S0: State where we haven't seen the first '1' yet
    // S1: State where we have seen the first '1'
    logic state, next_state;
    logic z_out;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    // Moore machine: output depends only on state
    always @(*) begin
        case (state)
            1'b0: z_out = x; // When no 1 has been seen yet, output is x
            1'b1: z_out = !x; // When 1 has been seen, flip bit
            default: z_out = 1'b0;
        endcase
    end

    always @(*) begin
        case (state)
            1'b0: begin
                if (x) next_state = 1'b1;
                else    next_state = 1'b0;
            end
            1'b1: begin
                next_state = 1'b1;
            end
            default: next_state = 1'b0;
        endcase
    end

    assign z = z_out;
endmodule
