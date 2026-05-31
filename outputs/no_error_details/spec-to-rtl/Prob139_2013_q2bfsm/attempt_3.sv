module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    localparam [3:0] 
        A = 0,
        F = 1,
        S1 = 2,
        S10 = 3,
        CHK1 = 4,
        CHK2 = 5,
        G_H = 6,
        G_L = 7;

    logic [3:0] state, next_state;

    always @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            A: next_state = F;
            F: next_state = (x == 1) ? S1 : F;
            S1: next_state = (x == 0) ? S10 : S1;
            S10: next_state = (x == 1) ? CHK1 : (x == 0 ? F : S10);
            CHK1: next_state = (y == 1) ? G_H : CHK2;
            CHK2: next_state = (y == 1) ? G_H : G_L;
            G_H: next_state = G_H;
            G_L: next_state = G_L;
            default: next_state = A;
        endcase
    end

    assign f = (state == F);
    assign g = (state == CHK1 || state == CHK2 || state == G_H);

endmodule
