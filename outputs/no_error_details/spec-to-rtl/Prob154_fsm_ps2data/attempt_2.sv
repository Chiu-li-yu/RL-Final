module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);

    logic [1:0] state;
    logic [7:0] b1, b2, b3;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'd0;
            b1 <= 8'd0;
            b2 <= 8'd0;
            b3 <= 8'd0;
        end else begin
            case (state)
                2'd0: begin // IDLE
                    if (in[3]) begin
                        b1 <= in;
                        state <= 2'd1;
                    end
                end
                2'd1: begin // GET_B2
                    b2 <= in;
                    state <= 2'd2;
                end
                2'd2: begin // GET_B3
                    b3 <= in;
                    state <= 2'd3;
                end
                2'd3: begin // DONE
                    if (in[3]) begin
                        b1 <= in;
                        state <= 2'd1;
                    end else begin
                        state <= 2'd0;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        done = (state == 2'd3);
        out_bytes = {b1, b2, b3};
    end

endmodule
