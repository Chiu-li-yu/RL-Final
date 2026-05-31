module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);
    // State definitions
    localparam A = 2'b00,
               B = 2'b01,
               C = 2'b10,
               D = 2'b11;

    logic [1:0] state, next_state;

    // State flip-flops
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // State table (next state logic)
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

    // FSM outputs
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);

endmodule
