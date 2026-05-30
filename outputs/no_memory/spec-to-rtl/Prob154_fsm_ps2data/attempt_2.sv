module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        BYTE2 = 2'd1,
        BYTE3 = 2'd2
    } state_t;

    state_t state, next_state;
    logic [7:0] b1, b2, b3;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            b1 <= 0;
            b2 <= 0;
            b3 <= 0;
            done <= 0;
            out_bytes <= 0;
        end else begin
            state <= next_state;
            done <= (state == BYTE3);
            if (state == BYTE3) begin
                out_bytes <= {b1, b2, in};
            end
            
            if (state == IDLE && in[3]) begin
                b1 <= in;
            end else if (state == BYTE2) begin
                b2 <= in;
            end else if (state == BYTE3) begin
                b3 <= in;
            end
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end
            end
            BYTE2: begin
                next_state = BYTE3;
            end
            BYTE3: begin
                if (in[3]) begin
                    next_state = BYTE2;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule
