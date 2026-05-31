module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        B2   = 2'd1,
        B3   = 2'd2
    } state_t;

    state_t state, next_state;
    logic [7:0] r1, r2, r3;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            r1 <= 8'h0;
            r2 <= 8'h0;
            r3 <= 8'h0;
            out_bytes <= 24'h0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            case (state)
                IDLE: if (in[3]) r1 <= in;
                B2:   r2 <= in;
                B3: begin
                    r3 <= in;
                    out_bytes <= {r1, r2, in};
                    done <= 1'b1;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (in[3]) next_state = B2;
            B2:   next_state = B3;
            B3:   next_state = IDLE;
        endcase
    end

endmodule
