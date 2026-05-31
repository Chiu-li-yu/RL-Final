module TopModule (
    input clk,
    input reset,
    input in,
    output logic out
);
    typedef enum logic {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= B;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            B: begin
                out = 1'b1;
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            default: begin
                out = 1'b1;
                next_state = B;
            end
        endcase
    end
endmodule
