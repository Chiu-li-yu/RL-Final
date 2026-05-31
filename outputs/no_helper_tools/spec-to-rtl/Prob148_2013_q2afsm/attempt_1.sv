module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    logic [2:0] state, next_state;

    localparam A = 3'b001, B = 3'b010, C = 3'b100, D = 3'b000; // D as dummy, A as reset state

    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D; // D represents grant for r2
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
