module TopModule (
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
    logic done_q;

    always @(posedge clk) begin
        if (reset) begin
            state <= BYTE1;
            done_q <= 1'b0;
        end else begin
            case (state)
                BYTE1: begin
                    done_q <= 1'b0;
                    if (in[3]) begin
                        state <= BYTE2;
                    end
                end
                BYTE2: begin
                    state <= BYTE3;
                end
                BYTE3: begin
                    state <= BYTE1;
                    done_q <= 1'b1;
                end
            endcase
        end
    end

    assign done = done_q;
endmodule
