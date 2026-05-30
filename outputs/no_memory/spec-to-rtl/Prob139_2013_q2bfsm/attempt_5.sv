module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        A, B, C, D, E, F, G, H, I
    } state_t;

    state_t current_state, next_state;
    logic [1:0] y_timer;

    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            y_timer <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == G) begin
                y_timer <= y_timer + 1;
            end else begin
                y_timer <= 0;
            end
        end
    end

    always @(*) begin
        next_state = current_state;
        f = 0;
        g = 0;

        case (current_state)
            A: next_state = B;
            B: begin
                f = 1;
                next_state = C;
            end
            C: if (x) next_state = D;
            D: if (!x) next_state = E; else next_state = C;
            E: if (x) next_state = F; else next_state = C;
            F: begin
                g = 1;
                next_state = G;
            end
            G: begin
                g = 1;
                if (y) next_state = H;
                else if (y_timer == 2) next_state = I;
            end
            H: g = 1;
            I: g = 0;
        endcase
    end
endmodule