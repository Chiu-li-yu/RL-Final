module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    logic [1:0] state;
    logic [1:0] next_state;
    logic done_reg;

    // State definitions
    localparam S0 = 2'd0; // Waiting for byte 1 (in[3] == 1)
    localparam S1 = 2'd1; // Received byte 1, waiting for byte 2
    localparam S2 = 2'd2; // Received byte 2, waiting for byte 3

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= (next_state == S0 && state == S2);
        end
    end

    always @(*) begin
        case (state)
            S0: begin
                if (in[3]) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                next_state = S2;
            end
            S2: begin
                next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    assign done = done_reg;

endmodule
