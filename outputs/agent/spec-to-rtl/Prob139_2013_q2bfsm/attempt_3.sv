
module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    localparam S_A = 2'd0, S_F = 2'd1, S_X = 2'd2, S_G = 2'd3;
    logic [1:0] state;
    logic [2:0] x_reg;
    logic [1:0] y_count;
    logic g_perm, g_off;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= S_A;
            x_reg <= 3'b0;
            y_count <= 2'b0;
            g_perm <= 1'b0;
            g_off <= 1'b0;
        end else begin
            case (state)
                S_A: begin
                    state <= S_F;
                end
                S_F: begin
                    state <= S_X;
                end
                S_X: begin
                    x_reg <= {x_reg[1:0], x};
                    if ({x_reg[1:0], x} == 3'b101) begin
                        state <= S_G;
                        y_count <= 2'b0;
                    end
                end
                S_G: begin
                    if (y) begin
                        g_perm <= 1'b1;
                        g_off <= 1'b0;
                    end else if (y_count == 2'd1) begin
                        g_off <= 1'b1;
                        g_perm <= 1'b0;
                    end
                    y_count <= y_count + 1'b1;
                end
            endcase
            if (g_perm || g_off) state <= S_G; // stay in a state where g is determined
        end
    end

    // The logic for g needs to be careful. 
    // g = 1 when in S_G, or when g_perm is 1.
    // Let's use a simpler state machine for g.
    
endmodule
