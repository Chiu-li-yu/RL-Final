
module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    localparam S_A      = 4'd0,
               S_F      = 4'd1,
               S_X0     = 4'd2,
               S_X1     = 4'd3,
               S_X2     = 4'd4,
               S_G1     = 4'd5,
               S_G2     = 4'd6,
               S_G_PERM = 4'd7,
               S_G_OFF  = 4'd8;

    logic [3:0] state, next_state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= S_A;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_A: begin
                if (resetn) 
                    next_state = S_F;
                else 
                    next_state = S_A;
            end
            S_F: begin
                if (x) 
                    next_state = S_X1;
                else 
                    next_state = S_X0;
            end
            S_X0: begin
                if (x) 
                    next_state = S_X1;
                else 
                    next_state = S_X0;
            end
            S_X1: begin
                if (!x) 
                    next_state = S_X2;
                else 
                    next_state = S_X1;
            end
            S_X2: begin
                if (x) 
                    next_state = S_G1;
                else 
                    next_state = S_X0;
            end
            S_G1: begin
                if (y) 
                    next_state = S_G_PERM;
                else 
                    next_state = S_G2;
            end
            S_G2: begin
                if (y) 
                    next_state = S_G_PERM;
                else 
                    next_state = S_G_OFF;
            end
            S_G_PERM: begin
                next_state = S_G_PERM;
            end
            S_G_OFF: begin
                next_state = S_G_OFF;
            end
            default: begin
                next_state = S_A;
            end
        endcase
    end

    assign f = (state == S_F);
    assign g = (state == S_G1 || state == S_G2 || state == S_G_PERM);

endmodule
