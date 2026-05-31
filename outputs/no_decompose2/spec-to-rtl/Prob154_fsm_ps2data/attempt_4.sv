module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output logic [23:0] out_bytes,
    output logic done
);
    logic [1:0] state; 
    logic [7:0] b1, b2;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
            out_bytes <= 24'b0;
            b1 <= 8'b0;
            b2 <= 8'b0;
        end else begin
            case (state)
                2'b00: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        b1 <= in;
                        state <= 2'b01;
                    end
                end
                2'b01: begin
                    done <= 1'b0;
                    b2 <= in;
                    state <= 2'b10;
                end
                2'b10: begin
                    done <= 1'b1;
                    out_bytes <= {b1, b2, in};
                    if (in[3]) begin
                        b1 <= in;
                        state <= 2'b01;
                    end else begin
                        state <= 2'b00;
                    end
                end
            endcase
        end
    end
endmodule
