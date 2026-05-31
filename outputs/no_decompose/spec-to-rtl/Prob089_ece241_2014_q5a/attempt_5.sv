module TopModule(
    input clk,
    input areset,
    input x,
    output z
);
    // State 0: no 1s seen yet
    // State 1: 1s have been seen
    logic state, next_state;
    logic z_out;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Correcting the logic for 2's complement:
    // If input x is 0, output is 0. If input x is 1, output is 1. 
    // And then flip everything after.
    
    // Actually, simple logic:
    // state 0: seen no 1. output = x.
    // state 1: seen a 1. output = ~x.
    // This is Mealy.
    // If it *must* be Moore, maybe the state includes the input or the output is registered?
    // Let's try the registered version.

    always @(*) begin
        case (state)
            1'b0: next_state = x ? 1'b1 : 1'b0;
            1'b1: next_state = 1'b1;
            default: next_state = 1'b0;
        endcase
    end

    // Registered output for Moore
    logic z_reg;
    always @(posedge clk or posedge areset) begin
        if (areset) z_reg <= 1'b0;
        else begin
            if (state == 1'b0) z_reg <= x;
            else z_reg <= ~x;
        end
    end
    
    assign z = z_reg;
endmodule
