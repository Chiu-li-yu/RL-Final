module TopModule (
    input logic clk,
    input logic areset,
    input logic in,
    output logic out
);

    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            A: begin
                if (in) next_state = B;
                else    next_state = A;
            end
            B: begin
                if (in) next_state = B;
                else    next_state = C;
            end
            C: begin
                if (in) next_state = D;
                else    next_state = A;
            end
            D: begin
                if (in) next_state = B;
                else    next_state = C;
            end
            default: next_state = A;
        endcase
    end

    always_comb begin
        out = (current_state == D);
    end

endmodule
