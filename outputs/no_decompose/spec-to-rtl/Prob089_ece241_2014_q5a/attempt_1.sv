module TopModule(
    input clk,
    input areset,
    input x,
    output z
);
    // State machine for 2's complementer
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

    always @(*) begin
        case (state)
            1'b0: begin // Found no '1' yet
                if (x) begin
                    next_state = 1'b1;
                    z_out = 1'b1;
                end else begin
                    next_state = 1'b0;
                    z_out = 1'b0;
                end
            end
            1'b1: begin // Found at least one '1'
                next_state = 1'b1;
                z_out = ~x;
            end
            default: begin
                next_state = 1'b0;
                z_out = 1'b0;
            end
        endcase
    end

    assign z = z_out;
endmodule
