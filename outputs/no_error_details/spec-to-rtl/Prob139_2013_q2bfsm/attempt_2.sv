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
        MON1 = 4,
        MON2 = 5,
        G_HIGH = 6,
        G_LOW = 7;

    logic [3:0] state, next_state;
    logic f_out, g_out;

    always @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            A: next_state = F;
            F: next_state = (x == 1) ? S1 : F;
            S1: next_state = (x == 0) ? S10 : (x == 1 ? S1 : F);
            S10: next_state = (x == 1) ? MON1 : (x == 0 ? F : S10);
            MON1: next_state = (y == 1) ? G_HIGH : MON2;
            MON2: next_state = (y == 1) ? G_HIGH : G_LOW;
            G_HIGH: next_state = G_HIGH;
            G_LOW: next_state = G_LOW;
            default: next_state = A;
        endcase
    end

    assign f = (state == F);
    assign g = (state == MON1 || state == MON2 || state == G_HIGH);

endmodule
