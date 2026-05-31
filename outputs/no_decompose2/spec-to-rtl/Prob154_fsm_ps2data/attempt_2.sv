module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);
    typedef enum logic [1:0] {
        S1 = 2'd0,
        S2 = 2'd1,
        S3 = 2'd2
    } state_t;

    state_t state;
    logic [7:0] b1, b2;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S1;
            done <= 1'b0;
            out_bytes <= 24'b0;
            b1 <= 8'b0;
            b2 <= 8'b0;
        end else begin
            case (state)
                S1: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        b1 <= in;
                        state <= S2;
                    end
                end
                S2: begin
                    done <= 1'b0;
                    b2 <= in;
                    state <= S3;
                end
                S3: begin
                    done <= 1'b1;
                    out_bytes <= {b1, b2, in};
                    if (in[3]) begin
                        b1 <= in;
                        state <= S2;
                    end else begin
                        state <= S1;
                    end
                end
            endcase
        end
    end
endmodule
