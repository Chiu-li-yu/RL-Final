module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        STATE_A, // Start
        STATE_B, // f=1
        STATE_C, // Got 1
        STATE_D, // Got 1-0
        STATE_E, // Got 1-0-1 -> g=1
        STATE_F, // g=1, monitor y
        STATE_G, // g=1 permanently
        STATE_H  // g=0 permanently
    } state_t;

    state_t state, next_state;
    logic [1:0] y_count;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (!resetn) begin
            y_count <= 2'b0;
        end else if (state == STATE_F) begin
            y_count <= y_count + 1'b1;
        end else begin
            y_count <= 2'b0;
        end
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: next_state = STATE_B;
            STATE_B: begin
                f = 1;
                next_state = (x == 1) ? STATE_C : STATE_B;
            end
            STATE_C: next_state = (x == 0) ? STATE_D : (x == 1 ? STATE_C : STATE_B);
            STATE_D: next_state = (x == 1) ? STATE_E : (x == 0 ? STATE_B : STATE_D);
            STATE_E: begin
                g = 1;
                next_state = STATE_F;
            end
            STATE_F: begin
                g = 1;
                if (y == 1) begin
                    next_state = STATE_G;
                end else if (y_count == 2) begin
                    next_state = STATE_H;
                end
            end
            STATE_G: begin
                g = 1;
            end
            STATE_H: begin
                g = 0;
            end
        endcase
    end
endmodule