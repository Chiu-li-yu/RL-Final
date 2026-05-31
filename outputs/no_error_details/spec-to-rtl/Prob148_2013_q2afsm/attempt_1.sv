module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);
    parameter A = 2'd0, B = 2'd1, C = 2'd2, D = 2'd3;
    logic [1:0] state, next_state;

    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            A: begin
                if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else next_state = A;
            end
            B: begin
                if (r[0]) next_state = B;
                else next_state = A;
            end
            C: begin
                if (r[1]) next_state = C;
                else next_state = A;
            end
            D: begin
                if (r[2]) next_state = D;
                else next_state = A;
            end
            default: next_state = A;
        endcase
    end

    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);
endmodule