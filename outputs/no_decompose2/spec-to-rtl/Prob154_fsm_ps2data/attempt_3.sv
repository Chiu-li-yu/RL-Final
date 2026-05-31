module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);
    logic [1:0] state; // 0: S1, 1: S2, 2: S3
    logic [7:0] reg_b1, reg_b2;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 2'd0;
            done <= 1'b0;
            out_bytes <= 24'b0;
            reg_b1 <= 8'b0;
            reg_b2 <= 8'b0;
        end else begin
            case (state)
                2'd0: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        reg_b1 <= in;
                        state <= 2'd1;
                    end
                end
                2'd1: begin
                    done <= 1'b0;
                    reg_b2 <= in;
                    state <= 2'd2;
                end
                2'd2: begin
                    out_bytes <= {reg_b1, reg_b2, in};
                    done <= 1'b1;
                    if (in[3]) begin
                        reg_b1 <= in;
                        state <= 2'd1;
                    end else begin
                        state <= 2'd0;
                    end
                end
            endcase
        end
    end
endmodule
