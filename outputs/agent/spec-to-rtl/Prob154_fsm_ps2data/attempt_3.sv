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

    state_t state;
    logic [23:0] shift_reg;
    logic [7:0] b1, b2;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            out_bytes <= 24'd0;
            b1 <= 8'd0;
            b2 <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        b1 <= in;
                        state <= BYTE2;
                    end
                end
                BYTE2: begin
                    done <= 1'b0;
                    b2 <= in;
                    state <= BYTE3;
                end
                BYTE3: begin
                    done <= 1'b1;
                    out_bytes <= {b1, b2, in};
                    if (in[3]) begin
                        b1 <= in;
                        state <= BYTE2;
                    end else begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
