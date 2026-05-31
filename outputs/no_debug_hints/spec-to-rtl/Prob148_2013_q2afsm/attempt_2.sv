module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    logic [1:0] state, next_state;
    logic [2:0] g_internal;

    assign g = g_internal;

    always_ff @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
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

    always_comb begin
        g_internal = 3'b000;
        case (state)
            B: g_internal = 3'b001;
            C: g_internal = 3'b010;
            D: g_internal = 3'b100;
            default: g_internal = 3'b000;
        endcase
    end
endmodule
