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

    state_t state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= BYTE1;
            done <= 1'b0;
        end else begin
            case (state)
                BYTE1: begin
                    if (in[3]) begin
                        state <= BYTE2;
                        done <= 1'b0;
                    end else begin
                        state <= BYTE1;
                        done <= 1'b0;
                    end
                end
                BYTE2: begin
                    state <= BYTE3;
                    done <= 1'b0;
                end
                BYTE3: begin
                    state <= BYTE1;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule
