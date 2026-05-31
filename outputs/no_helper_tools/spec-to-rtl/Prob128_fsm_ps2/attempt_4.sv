module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output logic done
);

    typedef enum logic [1:0] {
        BYTE1 = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= BYTE1;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (state == BYTE2) begin
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            BYTE1: begin
                if (in[3]) next_state = BYTE2;
                else next_state = BYTE1;
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                if (in[3]) next_state = BYTE2;
                else next_state = BYTE1;
            end
            default: next_state = BYTE1;
        endcase
    end
endmodule
