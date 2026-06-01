module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);
    logic [1:0] state; // 0: IDLE, 1: B2, 2: B3
    logic [7:0] b1, b2;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 2'd0;
            b1 <= 8'd0;
            b2 <= 8'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            case (state)
                2'd0: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        b1 <= in;
                        state <= 2'd1;
                    end
                end
                2'd1: begin
                    b2 <= in;
                    state <= 2'd2;
                end
                2'd2: begin
                    out_bytes <= {b1, b2, in};
                    done <= 1'b1;
                    state <= 2'd0;
                end
            endcase
        end
    end
endmodule