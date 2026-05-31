module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output logic done
);
    // 0: searching for byte 1
    // 1: received byte 1, waiting for byte 2
    // 2: received byte 2, waiting for byte 3
    // 3: received byte 3, done=1, back to byte 1
    logic [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
        end else begin
            case (state)
                2'b00: begin
                    done <= 1'b0;
                    if (in[3]) state <= 2'b01;
                    else state <= 2'b00;
                end
                2'b01: begin
                    done <= 1'b0;
                    state <= 2'b10;
                end
                2'b10: begin
                    done <= 1'b0;
                    state <= 2'b11;
                end
                2'b11: begin
                    done <= 1'b1;
                    if (in[3]) state <= 2'b01;
                    else state <= 2'b00;
                end
            endcase
        end
    end
endmodule