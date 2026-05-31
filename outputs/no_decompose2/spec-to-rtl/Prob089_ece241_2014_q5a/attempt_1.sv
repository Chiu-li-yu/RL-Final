module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    logic state, next_state;
    logic z_out;

    // States: 0 = No 1s seen yet, 1 = 1s seen
    parameter S0 = 1'b0;
    parameter S1 = 1'b1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S0: begin
                if (x == 1'b0) begin
                    next_state = S0;
                    z_out = 1'b0;
                end else begin
                    next_state = S1;
                    z_out = 1'b1;
                end
            end
            S1: begin
                if (x == 1'b0) begin
                    next_state = S1;
                    z_out = 1'b1;
                end else begin
                    next_state = S1;
                    z_out = 1'b0;
                end
            end
            default: begin
                next_state = S0;
                z_out = 1'b0;
            end
        endcase
    end

    assign z = z_out;
endmodule
